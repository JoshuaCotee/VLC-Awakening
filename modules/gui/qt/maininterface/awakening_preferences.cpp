// SPDX-License-Identifier: GPL-2.0-or-later
#include "awakening_preferences.hpp"
#include "player/player_controller.hpp"
#include "mainctx.hpp"
#include "util/color_scheme_model.hpp"
#include "util/audio_device_model.hpp"
#include "util/vlchotkeyconverter.hpp"
#include "medialibrary/mlthreadpool.hpp"

#include <QFileDialog>
#include <QSettings>
#include <QKeyEvent>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QImageReader>
#include <QCryptographicHash>
#include <cmath>
#include <vlc_actions.h>
#include <vlc_variables.h>
#include <vlc_player.h>
#include <vlc_modules.h>
#include <vlc_plugin.h>
#include <vlc_interface.h>

AwakeningPreferences::AwakeningPreferences(qt_intf_t *intf, QObject *parent)
    : QObject(parent), m_intf(intf)
{
    m_saveTimer.setSingleShot(true);
    m_saveTimer.setInterval(500);
    connect(&m_saveTimer, &QTimer::timeout, this, &AwakeningPreferences::save);
}

AwakeningPreferences::~AwakeningPreferences()
{
    if (m_dirty)
        save();
}

QVariant AwakeningPreferences::value(const QString &name) const
{
    const auto key = name.toUtf8();
    switch (config_GetType(key.constData()))
    {
    case VLC_VAR_BOOL:
        return bool(config_GetInt(key.constData()));
    case VLC_VAR_INTEGER:
        return QVariant::fromValue<qlonglong>(config_GetInt(key.constData()));
    case VLC_VAR_FLOAT:
        return config_GetFloat(key.constData());
    case VLC_VAR_STRING:
    {
        char *text = config_GetPsz(key.constData());
        const QString result = QString::fromUtf8(text ? text : "");
        free(text);
        return result;
    }
    default:
        return {};
    }
}

QVariantMap AwakeningPreferences::describe(const QString &name) const
{
    const auto key = name.toUtf8();
    const module_config_t *item = config_FindConfig(key.constData());
    if (!item)
        return {};

    const int type = config_GetType(key.constData());
    QVariantMap result {
        {QStringLiteral("name"), name},
        {QStringLiteral("description"), qfu(item->psz_longtext ? item->psz_longtext : item->psz_text)},
        {QStringLiteral("value"), value(name)},
        {QStringLiteral("type"), type == VLC_VAR_BOOL ? QStringLiteral("toggle")
                               : type == VLC_VAR_FLOAT ? QStringLiteral("number")
                               : type == VLC_VAR_INTEGER ? QStringLiteral("integer")
                               : QStringLiteral("text")}
    };
    QVariantList choices;
    if (type == VLC_VAR_INTEGER)
    {
        int64_t *values = nullptr;
        char **texts = nullptr;
        const ssize_t count = config_GetIntChoices(key.constData(), &values, &texts);
        for (ssize_t i = 0; i < count; ++i)
        {
            choices.append(QVariantMap{{QStringLiteral("text"), qfu(texts[i])},
                                       {QStringLiteral("value"), QVariant::fromValue<qlonglong>(values[i])}});
            free(texts[i]);
        }
        free(values);
        free(texts);
        result.insert(QStringLiteral("minimum"), QVariant::fromValue<qlonglong>(item->min.i));
        result.insert(QStringLiteral("maximum"), QVariant::fromValue<qlonglong>(item->max.i));
    }
    else if (type == VLC_VAR_STRING)
    {
        char **values = nullptr;
        char **texts = nullptr;
        const ssize_t count = config_GetPszChoices(key.constData(), &values, &texts);
        for (ssize_t i = 0; i < count; ++i)
        {
            choices.append(QVariantMap{{QStringLiteral("text"), qfu(texts[i])},
                                       {QStringLiteral("value"), qfu(values[i])}});
            free(values[i]);
            free(texts[i]);
        }
        free(values);
        free(texts);
    }
    else if (type == VLC_VAR_FLOAT)
    {
        result.insert(QStringLiteral("minimum"), item->min.f);
        result.insert(QStringLiteral("maximum"), item->max.f);
    }
    result.insert(QStringLiteral("choices"), choices);
    return result;
}

bool AwakeningPreferences::setValue(const QString &name, const QVariant &input)
{
    const auto key = name.toUtf8();
    const module_config_t *item = config_FindConfig(key.constData());
    if (!item)
    {
        setError(tr("This option is unavailable in this build."));
        return false;
    }
    bool valid = true;
    switch (config_GetType(key.constData()))
    {
    case VLC_VAR_BOOL:
        config_PutInt(key.constData(), input.toBool());
        break;
    case VLC_VAR_INTEGER:
    {
        const qlonglong number = input.toLongLong(&valid);
        valid = valid && number >= item->min.i && number <= item->max.i;
        if (valid)
            config_PutInt(key.constData(), number);
        break;
    }
    case VLC_VAR_FLOAT:
    {
        const float number = input.toFloat(&valid);
        valid = valid && std::isfinite(number) && number >= item->min.f && number <= item->max.f;
        if (valid)
            config_PutFloat(key.constData(), number);
        break;
    }
    case VLC_VAR_STRING:
        config_PutPsz(key.constData(), qtu(input.toString()));
        break;
    default:
        valid = false;
    }
    if (!valid)
    {
        setError(tr("Enter a value within the allowed range."));
        return false;
    }
    changed();
    return true;
}

QVariant AwakeningPreferences::state(const QString &name, const QVariant &fallback) const
{
    return m_intf->mainSettings->value(QStringLiteral("Awakening/") + name, fallback);
}

void AwakeningPreferences::setState(const QString &name, const QVariant &value)
{
    m_intf->mainSettings->setValue(QStringLiteral("Awakening/") + name, value);
    if (name == QStringLiteral("theme"))
    {
        const auto scheme = value == QStringLiteral("light") ? ColorSchemeModel::Day
                          : value == QStringLiteral("system") ? ColorSchemeModel::System
                          : ColorSchemeModel::Night;
        const auto choices = m_intf->p_mi->getColorScheme()->getSchemes();
        for (int i = 0; i < choices.size(); ++i)
            if (choices[i].scheme == scheme)
                m_intf->p_mi->getColorScheme()->setCurrentIndex(i);
    }
    changed();
}

bool AwakeningPreferences::resetValue(const QString &name)
{
    const auto key = name.toUtf8();
    const auto *item = config_FindConfig(key.constData());
    if (!item)
        return false;
    switch (config_GetType(key.constData()))
    {
    case VLC_VAR_BOOL: return setValue(name, bool(item->orig.i));
    case VLC_VAR_INTEGER: return setValue(name, QVariant::fromValue<qlonglong>(item->orig.i));
    case VLC_VAR_FLOAT: return setValue(name, item->orig.f);
    case VLC_VAR_STRING: return setValue(name, qfu(item->orig.psz ? item->orig.psz : ""));
    default: return false;
    }
}

bool AwakeningPreferences::filterEnabled(const QString &chain, const QString &name) const
{
    return value(chain).toString().split(':', Qt::SkipEmptyParts).contains(name);
}

bool AwakeningPreferences::setFilterEnabled(const QString &chain, const QString &name, bool enabled)
{
    if ((chain != QStringLiteral("audio-filter") && chain != QStringLiteral("video-filter")) ||
        !module_find(qtu(name)))
    {
        setError(tr("This effect is unavailable in this build."));
        return false;
    }
    QStringList filters = value(chain).toString().split(':', Qt::SkipEmptyParts);
    filters.removeAll(name);
    if (enabled)
        filters.append(name);
    if (!setValue(chain, filters.join(':')))
        return false;
    if (chain == QStringLiteral("audio-filter"))
        vlc_player_aout_EnableFilter(m_intf->p_player, qtu(name), enabled);
    else if (const auto vout = m_intf->p_mainPlayerController->getVout())
        var_SetString(vout.get(), "video-filter", qtu(filters.join(':')));
    return true;
}

bool AwakeningPreferences::setEffectValue(const QString &name, const QVariant &value, bool audio)
{
    if (!setValue(name, value))
        return false;
    const auto vout = audio ? SharedVOutThread{} : m_intf->p_mainPlayerController->getVout();
    const auto aout = audio ? m_intf->p_mainPlayerController->getAout() : SharedAOut{};
    vlc_object_t *object = audio ? (aout ? VLC_OBJECT(aout.get()) : nullptr)
                                 : (vout ? VLC_OBJECT(vout.get()) : nullptr);
    if (!object)
        return true;
    const auto key = name.toUtf8();
    const int type = config_GetType(key.constData());
    vlc_value_t output{};
    QByteArray text;
    switch (type)
    {
    case VLC_VAR_BOOL: output.b_bool = value.toBool(); break;
    case VLC_VAR_INTEGER: output.i_int = value.toLongLong(); break;
    case VLC_VAR_FLOAT: output.f_float = value.toFloat(); break;
    case VLC_VAR_STRING: text = value.toString().toUtf8(); output.psz_string = text.data(); break;
    default: return false;
    }
    var_SetChecked(object, key.constData(), type, output);
    return true;
}

QString AwakeningPreferences::choosePath(const QString &current, bool directory, bool write)
{
    if (directory)
        return QFileDialog::getExistingDirectory(nullptr, tr("Choose folder"), current);
    if (write)
        return QFileDialog::getSaveFileName(nullptr, tr("Choose file"), current);
    return QFileDialog::getOpenFileName(nullptr, tr("Choose file"), current);
}

void AwakeningPreferences::changed()
{
    setError({});
    m_dirty = true;
    ++m_revision;
    emit valuesChanged();
    m_saveTimer.start();
}

bool AwakeningPreferences::save()
{
    m_saveTimer.stop();
    if (!m_dirty)
        return true;
    m_intf->mainSettings->sync();
    if (config_SaveConfigFile(m_intf) != VLC_SUCCESS ||
        m_intf->mainSettings->status() != QSettings::NoError)
    {
        setError(tr("Settings could not be saved. Check that the configuration folder is writable."));
        return false;
    }
    m_dirty = false;
    return true;
}

void AwakeningPreferences::setError(const QString &error)
{
    if (m_error == error)
        return;
    m_error = error;
    emit errorChanged();
}

QVariantList AwakeningPreferences::shortcuts() const
{
    QVariantList result;
    unsigned count = 0;
    module_config_t *items = module_config_get(module_get_main(), &count);
    for (unsigned i = 0; i < count; ++i)
    {
        const auto &item = items[i];
        if (item.i_type != CONFIG_ITEM_KEY || strncmp(item.psz_name, "key-", 4))
            continue;
        const QString name = qfu(item.psz_name);
        result.append(QVariantMap{
            {QStringLiteral("option"), name},
            {QStringLiteral("label"), qfut(item.psz_text)},
            {QStringLiteral("local"), value(name)},
            {QStringLiteral("global"), value(QStringLiteral("global-") + name)},
            {QStringLiteral("description"), qfut(item.psz_longtext ? item.psz_longtext : item.psz_text)}
        });
    }
    module_config_free(items);
    return result;
}

QString AwakeningPreferences::shortcutText(int key, int modifiers) const
{
    QKeyEvent event(QEvent::KeyPress, key, Qt::KeyboardModifiers(modifiers));
    const auto code = qtEventToVLCKey(&event);
    char *text = vlc_keycode2str(code, false);
    const QString result = qfu(text ? text : "");
    free(text);
    return result;
}

void AwakeningPreferences::resetShortcuts()
{
    for (const auto &row : shortcuts())
    {
        const QString name = row.toMap().value(QStringLiteral("option")).toString();
        resetValue(name);
        resetValue(QStringLiteral("global-") + name);
    }
}

QVariantList AwakeningPreferences::audioDevices() const
{
    const auto *model = m_intf->p_mainPlayerController->getAudioDevices();
    QVariantList result;
    for (int i = 0; i < model->rowCount(); ++i)
        result.append(QVariantMap{
            {QStringLiteral("text"), model->data(model->index(i, 0), Qt::DisplayRole)},
            {QStringLiteral("value"), i}
        });
    return result;
}

int AwakeningPreferences::currentAudioDevice() const
{
    const auto *model = m_intf->p_mainPlayerController->getAudioDevices();
    for (int i = 0; i < model->rowCount(); ++i)
        if (model->data(model->index(i, 0), Qt::CheckStateRole).toBool())
            return i;
    return -1;
}

bool AwakeningPreferences::selectAudioDevice(int row)
{
    auto *model = m_intf->p_mainPlayerController->getAudioDevices();
    const bool result = model->setData(model->index(row, 0), true, Qt::CheckStateRole);
    if (result)
        changed();
    return result;
}

bool AwakeningPreferences::interfaceEnabled(const QString &name) const
{
    return value(QStringLiteral("extraintf")).toString().split(':').contains(name)
        || value(QStringLiteral("control")).toString().split(':').contains(name);
}

void AwakeningPreferences::setInterfaceEnabled(const QString &name, bool enabled)
{
    if (name != QStringLiteral("audioscrobbler") && name != QStringLiteral("http"))
        return;
    if (enabled)
        config_AddIntf(qtu(name));
    else
        config_RemoveIntf(qtu(name));
    changed();
}

QUrl AwakeningPreferences::localUrl(const QString &path) const
{
    return QUrl::fromLocalFile(path);
}

QString AwakeningPreferences::mediaFolder() const
{
    return QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
}

quint64 AwakeningPreferences::requestFolder(const QUrl &url)
{
    struct Listing { QVariantList items; QString error; };
    const bool hidden = value(QStringLiteral("show-hiddenfiles")).toBool();
    return m_intf->p_mi->threadRunner()->runOnThread<Listing>(this,
        [url, hidden](Listing &result) {
            QDir directory(url.toLocalFile());
            if (!url.isLocalFile() || !directory.exists() || !QFileInfo(directory.path()).isReadable())
            {
                result.error = tr("This folder is unavailable.");
                return;
            }
            auto filters = QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot;
            if (hidden) filters |= QDir::Hidden;
            const auto extensions = QStringLiteral(EXTENSIONS_MEDIA).split(';');
            const auto files = directory.entryInfoList(filters, QDir::DirsFirst | QDir::Name | QDir::IgnoreCase);
            for (const auto &file : files)
            {
                if (!file.isDir() && !QDir::match(extensions, file.fileName()))
                    continue;
                result.items.append(QVariantMap{
                    {QStringLiteral("title"), file.fileName()},
                    {QStringLiteral("url"), QUrl::fromLocalFile(file.absoluteFilePath())},
                    {QStringLiteral("isFolder"), file.isDir()}
                });
            }
        },
        [this, url](quint64 taskId, Listing &result) {
            emit folderLoaded(taskId, url, result.items, result.error);
        });
}

QList<QUrl> AwakeningPreferences::chooseMediaFiles()
{
    return QFileDialog::getOpenFileUrls(nullptr, tr("Select media files"), {},
        tr("Media files (%1);;All files (*)").arg(QStringLiteral(EXTENSIONS_MEDIA).replace(';', ' ')));
}

QUrl AwakeningPreferences::chooseArtwork()
{
    const auto path = QFileDialog::getOpenFileName(nullptr, tr("Choose playlist thumbnail"), {},
                                                  tr("Images (*.png *.jpg *.jpeg *.webp)"));
    if (path.isEmpty())
        return {};
    QFile file(path);
    if (file.size() > 20 * 1024 * 1024 || !QImageReader(path).canRead() || !file.open(QIODevice::ReadOnly))
    {
        setError(tr("Choose a readable image smaller than 20 MB."));
        return {};
    }
    const auto digest = QCryptographicHash::hash(file.readAll(), QCryptographicHash::Sha256).toHex();
    const auto directory = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
                           + QStringLiteral("/Awakening/artwork");
    const auto destination = directory + '/' + QString::fromLatin1(digest) + '.'
                             + QFileInfo(path).suffix().toLower();
    if (!QDir().mkpath(directory) || (!QFile::exists(destination) && !QFile::copy(path, destination)))
    {
        setError(tr("The playlist thumbnail could not be saved."));
        return {};
    }
    return QUrl::fromLocalFile(destination);
}

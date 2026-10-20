// SPDX-License-Identifier: GPL-2.0-or-later
#ifndef AWAKENING_PREFERENCES_HPP
#define AWAKENING_PREFERENCES_HPP

#include "qt.hpp"
#include <QObject>
#include <QTimer>
#include <QVariant>

class AwakeningPreferences final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(unsigned revision READ revision NOTIFY valuesChanged FINAL)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged FINAL)

public:
    explicit AwakeningPreferences(qt_intf_t *intf, QObject *parent = nullptr);
    ~AwakeningPreferences() override;

    unsigned revision() const { return m_revision; }
    QString error() const { return m_error; }

    Q_INVOKABLE QVariant value(const QString &name) const;
    Q_INVOKABLE QVariantMap describe(const QString &name) const;
    Q_INVOKABLE bool setValue(const QString &name, const QVariant &value);
    Q_INVOKABLE bool resetValue(const QString &name);
    Q_INVOKABLE bool filterEnabled(const QString &chain, const QString &name) const;
    Q_INVOKABLE bool setFilterEnabled(const QString &chain, const QString &name, bool enabled);
    Q_INVOKABLE bool setEffectValue(const QString &name, const QVariant &value, bool audio);
    Q_INVOKABLE QVariant state(const QString &name, const QVariant &fallback = {}) const;
    Q_INVOKABLE void setState(const QString &name, const QVariant &value);
    Q_INVOKABLE QString choosePath(const QString &current, bool directory, bool save = false);
    Q_INVOKABLE bool save();
    Q_INVOKABLE QVariantList shortcuts() const;
    Q_INVOKABLE QString shortcutText(int key, int modifiers) const;
    Q_INVOKABLE void resetShortcuts();
    Q_INVOKABLE QVariantList audioDevices() const;
    Q_INVOKABLE int currentAudioDevice() const;
    Q_INVOKABLE bool selectAudioDevice(int row);
    Q_INVOKABLE bool interfaceEnabled(const QString &name) const;
    Q_INVOKABLE void setInterfaceEnabled(const QString &name, bool enabled);

signals:
    void valuesChanged();
    void errorChanged();

private:
    void changed();
    void setError(const QString &error);
    qt_intf_t *m_intf;
    QTimer m_saveTimer;
    unsigned m_revision = 0;
    bool m_dirty = false;
    QString m_error;
};

#endif

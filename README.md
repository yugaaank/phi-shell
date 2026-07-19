<div align="center">

# 🐚 phi-shell

**A QML-based desktop shell — modular components, services, and themable colors.**

[![Stack](https://img.shields.io/badge/stack-QML%20%2F%20Qt-8b5cf6?style=for-the-badge)](https://doc.qt.io)
[![Status](https://img.shields.io/badge/status-WIP-8b5cf6?style=for-the-badge)](#)
[![PRs](https://img.shields.io/badge/PRs-welcome-8b5cf6?style=for-the-badge)](#contributing)

</div>

---

<div align="center">

| | |
|---|---|
| 🎯 **Purpose** | Desktop shell built on QML/Qt |
| 🧩 **Stack** | QML · Qt · JSON config |
| 🌑 **Theme** | Dark / rich |
| 📦 **Status** | In development |

</div>

---

## ✨ Features

- 🧩 **Modular** — `core/`, `modules/`, `services/`, `components/`
- 🎨 **Themable** — `colors.json` + `apps.json` drive look and launchers
- 🖥️ Entry point `shell.qml` with a service-test harness (`test_svc.qml`)
- 🔧 `scripts/` for build / dev helpers

## 🚀 Quick start

```bash
# open the shell with qmlscene (or your Qt runtime)
qmlscene shell.qml
```

## 📁 Structure

```
phi-shell/
├── shell.qml         # entry point
├── core/  modules/  services/  components/
├── config.json  colors.json  apps.json
└── scripts/
```

## 🤝 Contributing

PRs welcome — match the dark/rich README style.

## 📜 License

MIT © Yugank Rathore

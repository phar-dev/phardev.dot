---
description: Create AGENTS.md based on my workflow
agent: phardev
skills:
  - skill-creator
  - skill-finder
  - skill-registry
---

Load skill-creator, skill-finder, and skill-registry skills first, then:

Analiza este proyecto y crea un `AGENTS.md` siguiendo el estándar oficial de la industria ("README for agents").
**IMPORTANTE**: El documento resultante DEBE tener MENOS DE 200 LÍNEAS para no saturar la ventana de contexto del LLM. Mantén descripciones ultra-concisas. Estructura el archivo exactamente así:

# [NOMBRE-PROJECTO] - Agent Instructions

<context>
Breve resumen (1-2 párrafos) del propósito del proyecto y el stack tecnológico.
</context>

<rules>
## ⚠️ Core Directives
- **DO**: Leer `.agents/skills/project-index/SKILL.md` antes de codear.
- **DO**: Correr tests locales tras cada cambio.
- **DO**: Usar Context7 MCP proactivamente para documentación de APIs/librerías actualizadas.
- **DON'T**: Inventar dependencias o APIs.
- **DON'T**: Modificar configuraciones globales sin pedir permiso.
</rules>

<architecture>
## 🎯 Arquitectura
- **Backend/API**: [Stack]
- **Frontend/UI**: [Stack]
- **DB/Storage**: [Stack]
- **Commands**: `[dev command]`, `[test command]`
</architecture>

<skills>
## 🧠 Agent Skills (`.agents/skills/`)
Este repositorio usa el estándar abierto "Agent Skills". Los conocimientos técnicos están encapsulados en skills.

| Categoría | Ubicación | Propósito |
|-----------|-----------|-----------|
| **Core** | `.agents/skills/project-index/` | Punto de entrada obligatorio |
| **Patterns** | `.agents/skills/[pattern]/` | Patrones de arquitectura |
| **Gestión** | `.agents/skills/skill-registry/` | Lista completa de skills disponibles |

*Agentes: Busca la skill que necesites en el registry antes de empezar una tarea, o usa `skill-creator` para guardar nuevos patrones.*
</skills>

---
**Instrucciones para ti (el generador del AGENTS.md):**
1. **Límite Estricto**: MÁXIMO 200 líneas en el archivo final. Elimina texto innecesario ("fluff").
2. **Reemplazo total**: Usa `.agents/skills/` en TODAS las rutas. No uses `skills/`.
3. **Markdown Limpio**: Usa tags XML `<context>`, `<rules>`, `<architecture>`, `<skills>` como envoltorios para que el LLM lo entienda perfecto.
4. **Context7**: Incluye la regla de Context7.

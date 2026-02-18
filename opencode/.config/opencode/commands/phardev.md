---
description: Create AGENTS.md based on my workflow
agent: phardev
skills:
  - skill-creator
  - skill-finder
  - skill-registry
---

Load skill-creator, skill-finder, and skill-registry skills first, then:

Analiza este proyecto y crea un AGENTS.md que sirva como índice/guía de navegación del sistema de skills.
**IMPORTANTE**: NO crear un documento técnico detallado. El AGENTS.md debe ser un ÍNDICE que explique CÓMO FUNCIONA EL PROYECTO usando los documentos disponibles.
**Estructura requerida:**

# [NOMBRE-PROJECTO] - [Descripción breve]

**AI Agent Framework para [Stack/Arquitectura principal]**
Este proyecto utiliza un **sistema de skills** para organizar conocimientos y patrones de desarrollo. Los agentes AI cargan automáticamente las skills relevantes basándose en el contexto.

## 🎯 ¿Cómo funciona este proyecto?

### Arquitectura Principal

- **[Componente 1]**: [Stack/tecnología]
- **[Componente 2]**: [Stack/tecnología]
- **Testing**: [Herramientas de testing]
- **Entorno**: [Entorno de desarrollo]

### Sistema de Skills

El proyecto está organizado en skills reutilizables que encapsulan
conocimientos específicos:
skills/
├── Generic Skills/ # Reutilizables en CUALQUIER proyecto
├── Architecture Patterns/ # Patrones específicos de esta arquitectura
└── Project-Specific/ # Únicos para este proyecto

## 🚀 Guía de Navegación

### 🆕 **Punto de entrada principal**

→ **[`skills/project-index/SKILL.md`](skills/project-index/SKILL.md)**

- Resumen del proyecto
- Comandos de desarrollo
- Arquitectura general
- Navegación de skills

### 📚 **Skills por Categoría**

#### Generic Skills (Reutilizables)

| Skill    | Propósito     | Documento                                              |
| -------- | ------------- | ------------------------------------------------------ |
| [skill1] | [descripción] | [`skills/[skill1]/SKILL.md`](skills/[skill1]/SKILL.md) |
| [skill2] | [descripción] | [`skills/[skill2]/SKILL.md`](skills/[skill2]/SKILL.md) |

#### Architecture Patterns (Esta Arquitectura)

| Skill        | Tipo             | Propósito     | Documento                                                      |
| ------------ | ---------------- | ------------- | -------------------------------------------------------------- |
| [pattern1]   | 📚 **Patrones**  | [descripción] | [`skills/[pattern1]/SKILL.md`](skills/[pattern1]/SKILL.md)     |
| [generator1] | ⚙️ **Generador** | [descripción] | [`skills/[generator1]/SKILL.md`](skills/[generator1]/SKILL.md) |

#### Project-Specific (Este Proyecto)

| Skill           | Propósito     | Documento                                                            |
| --------------- | ------------- | -------------------------------------------------------------------- |
| [project-skill] | [descripción] | [`skills/[project-skill]/SKILL.md`](skills/[project-skill]/SKILL.md) |

### 🛠️ **Skills de Gestión**

| Skill          | Propósito                      | Documento                                                          |
| -------------- | ------------------------------ | ------------------------------------------------------------------ |
| skill-registry | Gestión del registro de skills | [`skills/skill-registry/SKILL.md`](skills/skill-registry/SKILL.md) |
| skill-creator  | Crear nuevas skills            | [`skills/skill-creator/SKILL.md`](skills/skill-creator/SKILL.md)   |

## 🔄 **Cómo trabajar en este proyecto**

### 1. **Inicio Rápido**

```bash
# Leer el overview del proyecto
cat skills/project-index/SKILL.md
# Ver todas las skills disponibles
cat skills/skill-registry/assets/registry.json
2. Para tareas específicas
Los agentes cargan automáticamente las skills relevantes según el contexto:
- Contexto específico 1 → Carga [skill-relevante]
- Contexto específico 2 → Carga [skill-relevante]
3. Para crear nueva funcionalidad
- Tipo tarea 1: Usar [generador-skill] para scaffolding
- Tipo tarea 2: Usar [generador-skill] para scaffolding
- Nuevo patrón: Usar skill-creator para documentarlo
📖 Documentación Adicional
- skills/README.md (skills/README.md): Framework completo de skills
- AGENTS.md (este archivo): Punto de entrada y navegación
🎯 Flujo de Trabajo Recomendado
1. Nueva tarea → Leer project-index para contexto
2. Identificar skill → Buscar en skill-registry o usar skill-finder
3. Leer skill específico → Seguir patrones documentados
4. Implementar → Usar generadores si aplica
5. Documentar → Crear nueva skill si es patrón nuevo
🤝 Para Agentes AI
- Siempre invocar la skill apropiada antes de trabajar en tareas específicas
- Leer project-index en cada nueva sesión
- Usar skill-finder para encontrar skills relevantes
- Crear skills nuevas para patrones que se repitan
---
🚀 Happy coding! Este sistema asegura consistencia y acelera el desarrollo al encapsular conocimientos específicos del proyecto.
**Instrucciones agnósticas del framework:**
1. **Identifica la arquitectura del proyecto**:
   - ¿Qué tecnologías usa? (Node.js, Python, Go, etc.)
   - ¿Qué componentes tiene? (API, frontend, base de datos, etc.)
   - ¿Cómo está estructurado?
2. **Adapta los componentes**:
   - `[Componente 1]`: API, Backend, Frontend, Base de datos, etc.
   - `[Stack/tecnología]`: Express.js, FastAPI, React, Vue, PostgreSQL, etc.
3. **Personaliza los contextos**:
   - **[Contexto específico 1]**: Según la estructura del proyecto
   - Ej: "Trabajando en `src/api/`" → Carga `api-patterns`
   - Ej: "Mencionando 'autenticación'" → Carga `auth-skill`
4. **Mantén la estructura genérica**:
   - Las categorías (Generic, Architecture, Project-Specific) funcionan para cualquier tecnología
   - Los tipos de skills (📚 Patrones vs ⚙️ Generadores) son universales
**Ejemplos para diferentes stacks:**
- **Node.js + React**: "Backend: Node.js + Express", "Frontend: React + TypeScript"
- **Python + FastAPI**: "API: Python + FastAPI", "Base de datos: PostgreSQL + SQLAlchemy"
- **Go + Vue**: "Backend: Go + Gin", "Frontend: Vue.js + TypeScript"
```

---
name: notion-mcp
description: >
  Integración con Notion MCP para gestionar páginas, bases de datos, comentarios y usuarios.
  Trigger: cuando el usuario menciona "notion", "página de notion", "buscar en notion",
  "crear página", "actualizar notion", "base de datos notion".
license: Apache-2.0
metadata:
  version: "1.0.0"
---

## When to Use

- Leer o escribir páginas de Notion
- Crear o modificar bases de datos
- Buscar contenido en el workspace
- Gestionar comentarios y usuarios

## Critical Patterns

### Herramientas Disponibles (14 tools)

**Content Management:**

- `notion-search` - Búsqueda semántica en workspace y fuentes conectadas
- `notion-fetch` - Obtener contenido de página/database por URL/ID
- `notion-create-pages` - Crear páginas con propiedades y contenido
- `notion-update-page` - Actualizar propiedades, contenido, icon, cover

**Database Management:**

- `notion-create-database` - Crear database con schema SQL DDL
- `notion-update-data-source` - Modificar schema (ADD/DROP/RENAME COLUMN)
- `notion-create-view` - Crear vista (table, board, calendar, etc.)
- `notion-update-view` - Actualizar filtros, sorts, configuración

**Collaboration:**

- `notion-create-comment` - Agregar comentario a página o bloque
- `notion-get-comments` - Listar comentarios y discusiones

**Workspace:**

- `notion-get-users` - Listar usuarios del workspace
- `notion-get-teams` - Listar teams/teamspaces
- `notion-move-pages` - Mover páginas a nuevo parent
- `notion-duplicate-page` - Duplicar página (async)

## Code Examples

```typescript
// Buscar en Notion
(await notion_notion) -
  search({
    query: "proyecto API",
    query_type: "internal",
    page_size: 10
  });

// Fetch de página
(await notion_notion) -
  fetch({
    id: "https://notion.so/workspace/Page-1234567890"
  });

// Crear página
(await notion_notion) -
  create -
  pages({
    parent: { page_id: "parent-page-id" },
    pages: [
      {
        properties: { title: "Nueva Página" },
        content: "# Contenido\n\nTexto..."
      }
    ]
  });

// Actualizar página
(await notion_notion) -
  update -
  page({
    page_id: "page-id",
    command: "update_content",
    content_updates: [
      {
        old_str: "# Old Section",
        new_str: "# New Section\nNuevo contenido"
      }
    ]
  });

// Crear database
(await notion_notion) -
  create -
  database({
    parent: { page_id: "parent-page-id" },
    title: "Tareas",
    schema: `CREATE TABLE (
    "Name" TITLE,
    "Status" SELECT('To Do':red, 'Done':green),
    "Due Date" DATE
  )`
  });
```

## Notion Markdown Format

Usar formato Notion-flavored Markdown:

- Headers: `# Title`, `## Section`
- Listas: `- Item`, `1. Numbered`
- Código: ```language
- Negrita: **text**
- Links: [text](url)

## Commands

```bash
# Instalación MCP
npx @notionhq/notion-mcp@latest
```

## Resources

- **Docs**: <https://developers.notion.com/guides/mcp/mcp-supported-tools>
- **Enhanced Markdown**: Consultar `notion://docs/enhanced-markdown-spec`


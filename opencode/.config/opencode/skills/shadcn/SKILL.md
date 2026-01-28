---
name: shadcn
description: >
  Manages shadcn/ui components installation, customization, and usage.
  Trigger: When user asks to add shadcn components or modify UI.
license: Apache-2.0
metadata:
  author: opencode
  version: '1.0'
  scope: [root]
  auto_invoke: 'Adding shadcn components'
---

## When to Use

- Installing new shadcn/ui components
- Customizing existing shadcn components
- Ensuring UI consistency with project conventions
- Modifying component styles or behavior

## Critical Patterns

- Use `pnpm dlx shadcn@latest add <component>` to install components
- Components are typically located in `components/ui/` or your project's designated UI components directory
- Follow `tailwind-4` skill for styling conventions
- Follow `react-19` skill for React patterns
- Use `cn()` utility for conditional class merging
- Customize components by editing the `ui/` files directly
- Import components from `@/components/ui/<component>`

## Code Examples

### Adding a Button Component

```bash
pnpm dlx shadcn@latest add button
```

```tsx
import { Button } from '@/components/ui/button'

export function MyComponent() {
  return <Button variant="default">Click me</Button>
}
```

### Customizing a Component

Edit `components/ui/button.tsx` to add custom variants or styles.

## Commands

```bash
# Add a new component
pnpm dlx shadcn@latest add <component>

# Initialize shadcn (if not already done)
pnpm dlx shadcn@latest init
```

## Resources

- **Configuration**: See [components.json](../../components.json) for shadcn configuration
- **Documentation**: See [references/](references/) for local docs

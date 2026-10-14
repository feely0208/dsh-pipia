import { createPlugin, pkgRootFrom } from '@deepwhale-cn/dsh-guard-core/plugin';

export const { name, inject, apply } = createPlugin({
  name: 'pipia',
  pkgRoot: pkgRootFrom(import.meta.url),
  skillFile: 'skill/pipia.md',
  binFile: 'bin/cli.mjs',
  description: '查是否按个保法 55 条做了影响评估、按 56 条留存三年 —— 敏感信息处理必须事前评估',
  whenToUse: 'TODO：写清什么时候该用（用户会说的话也列上）',
});

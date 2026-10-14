# @deepwhale-cn/dsh-pipia

**个人信息保护影响评估** —— 查是否按个保法 55 条做了评估、56 条留存三年。

## 不装它会怎样

你的代码里有人脸核身：

```js
const faceId = await extractFace(imageBase64);
await push(userId, { userInfo: await getUser(userId), faceId });
```

**业务上没问题。法律上踩了第 55 条：**

> **《个人信息保护法》第五十五条**
> 处理**敏感个人信息**、利用个人信息进行自动化决策、
> 委托处理 / 向他人提供 / 公开个人信息、向境外提供个人信息
> —— **应当事前进行个人信息保护影响评估，并对处理情况进行记录**

> **第五十六条**
> 评估报告和处理情况记录应当**至少保存三年**。

**这条是「必须做」，不是「最好做」。** 而且监管检查时会**直接要求出示**。

## 关键词
**关键词**：个人信息保护影响评估 · 影响评估 · PIPIA · DPIA · 敏感个人信息 · 合规评估 · 评估报告 · 保存三年
**Keywords**: PIPIA · DPIA · privacy impact assessment · PIPL · sensitive personal information

## 它查什么

| 级别 | 内容 |
|---|---|
| 🔴 高 | 处理**敏感个人信息**但找不到评估 | 处理**对外提供**但找不到评估 |
| 🟡 中 | 仓库里找不到任何评估记录 | |
| 🟢 低 | 提到了评估但**没写保存期限**（56 条要求三年）| |

## 两条规则是「条件适用」的

`PIPIA-SENSITIVE-NO-ASSESS` 和 `PIPIA-THIRD-PARTY-NO-ASSESS` **只在项目确实有相应处理活动时才跑**。
没有敏感信息的项目跑这两条就是误报 —— 引擎的条件规则能力（`check.when`）。

## 安装

```bash
dsh plugin --profile web add @deepwhale-cn/dsh-pipia
# 或纯 CLI
npx @deepwhale-cn/dsh-pipia
```

![dsh-pipia 检查报告示例](https://www.deepwhale.org.cn/plugin-assets/dsh-pipia/report.png)

![dsh-pipia 演示模式输出](https://www.deepwhale.org.cn/plugin-assets/dsh-pipia/demo.png)

![dsh-pipia 规则与依据](https://www.deepwhale.org.cn/plugin-assets/dsh-pipia/rules.png)

## 用法

```bash
dsh-pipia --demo
dsh-pipia --list-rules
dsh-pipia --html r.html
```

## 边界

- **不会替你写评估报告** —— 它只发现「你处理了这些活动，但找不到评估痕迹」。
- **评估通常在仓库外**（法务文档、内部系统）—— 报出来是提示你确认，不是断定你没做。
- **敏感信息靠字段/关键词识别** —— 自定义命名会漏。
- **不做「必要性」判断** —— 该项处理是否属于必须评估的情形，最终是法律判断。
- 与 [dsh-cn-data-export](https://github.com/feely0208/dsh-cn-data-export) 分工：
  那个查**数据出境**，这个查**评估流程**（出境也是必须评估的情形之一）。

本插件是一个工具。使用者必须遵守所在地区法律法规，**对使用本项目造成的任何后果自行承担责任。**

## License

MIT © 深鲸 DeepWhale

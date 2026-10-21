[English](../../README.md) | **简体中文**

# 定量研究作品集

**曼彻斯特大学 · 社会研究方法与统计学硕士**

## 作品集简介

本作品集汇集了我在硕士课程中完成的统计研究，重点展示[纵向数据分析](../../projects/elsa-loneliness/README.md)、[Logistic 回归](../../projects/ess9-statistical-modelling/README.md)、[多层模型](../../projects/ess9-statistical-modelling/README.md#part-2--household-income-and-internet-use-across-countries)、[统计结果解释](../../projects/ess9-statistical-modelling/MODEL_TO_INTERPRETATION.md)以及[模型设定与数据质量检查](../../docs/elsa-audit.md)等研究能力。这些方法同样可用于以数据和证据支持决策的研究与分析工作。

---

## 研究项目

| 项目 | 研究问题 | 分析方法 | 证据状态 |
| --- | --- | --- | --- |
| [ELSA：社会参与与孤独感](../../projects/elsa-loneliness/README.md) | 社会组织参与如何与老年人的孤独感水平及其变化相关？ | 五轮纵向数据整理、混合效应增长模型 | 已记录课程作业的独立复核；**R 脚本尚未执行验证** |
| [ESS9：收入、犯罪受害经历与互联网使用](../../projects/ess9-statistical-modelling/README.md) | 收入与英国的犯罪受害经历、跨国互联网使用时间有何关联？ | 二元 Logistic 回归、国家层级随机截距模型 | **课程提交稿中的结果**；尚未独立重新运行 |

---

## 研究能力与对应证据

| 研究能力 | 我具体做了什么 | 研究证据 |
| --- | --- | --- |
| **纵向数据分析** | 整理五轮调查数据，区分个人和重复观测，分析孤独感随时间的变化。 | [ELSA 研究设计 →](../../projects/elsa-loneliness/README.md) |
| **回归建模** | 对犯罪受害这一二元结局使用 Logistic 回归，解释优势比及置信区间。 | [ESS9 Logistic 模型 →](../../projects/ess9-statistical-modelling/README.md#part-1--household-income-and-crime-victimisation-in-great-britain) |
| **多层模型** | 建立国家随机截距模型分析互联网使用，同时使用纵向混合效应模型处理个体差异。 | [ESS9 多层模型 →](../../projects/ess9-statistical-modelling/README.md#part-2--household-income-and-internet-use-across-countries) · [ELSA →](../../projects/elsa-loneliness/README.md) |
| **统计解释** | 解释回归系数、时间交互项，并区分统计关联与因果效应。 | [ESS9 研究反思 →](../../projects/ess9-statistical-modelling/README.md#research-choices-and-limitations) · [ELSA 结果 →](../../projects/elsa-loneliness/README.md#findings-and-interpretation) |
| **模型核查与研究透明性** | 检查样本量、变量编码，并对照课程提交结果与后续独立复核结果。 | [ELSA 复核记录 →](../../docs/elsa-audit.md) · [ESS9 局限 →](../../projects/ess9-statistical-modelling/README.md#research-choices-and-limitations) |

---

## 阅读导航

| 内容 | 查看英文详细页面 |
| --- | --- |
| ELSA 纵向研究 | [研究设计、模型与结果 →](../../projects/elsa-loneliness/README.md) |
| ELSA 复核记录 | [样本与模型核查 →](../../docs/elsa-audit.md) |
| ELSA R 脚本 | [待完整运行验证的脚本 →](../../scripts/elsa_reproduce.R) |
| ESS9 建模研究 | [Logistic 与多层模型 →](../../projects/ess9-statistical-modelling/README.md) |
| ESS9 模型证据解读 | [模型设定 → 结果 → 解释 →](../../projects/ess9-statistical-modelling/MODEL_TO_INTERPRETATION.md) |

详细研究内容保留英文。

## 其他研究

- [硕士毕业论文：线上社会连接与英国移民心理健康](https://github.com/Fenty-zhao/immigrant-social-connection-mental-health/blob/main/docs/zh/README.md) — 采用个体固定效应的纵向研究
- [质性研究作品集](https://github.com/Fenty-zhao/qualitative-research-portfolio/blob/main/docs/zh/README.md) — 访谈、编码、主题分析与研究者反思
- [游戏直播社群用户研究](https://github.com/Fenty-zhao/gaming-livestream-community-research/blob/main/docs/zh/README.md) — 用户行为与社群研究

## 数据使用与透明说明

本作品集区分**原课程提交结果**与**后续独立复核**，不公开受访问条件限制的原始数据。ELSA 的结果在整理作品集时经过独立复核，所准备的 R 脚本尚未在 R 环境中完整验证；ESS9 的模型结果尚未独立重现。文中统计关联不等于已经确立的因果效应。

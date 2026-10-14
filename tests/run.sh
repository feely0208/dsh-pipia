#!/bin/bash
set -uo pipefail
cd "$(dirname "$0")/.."
PASS=0; FAIL=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
bad(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }
echo ""; echo "  @deepwhale-cn/dsh-pipia · 双向验证"
echo "  ────────────────────────────────────────────────"
J=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --json 2>&1)
for rid in PIPIA-SENSITIVE-NO-ASSESS PIPIA-THIRD-PARTY-NO-ASSESS PIPIA-NO-RECORD; do
  c=$(echo "$J" | python3 -c "
import json,sys; d=json.load(sys.stdin)
print(len([f for f in d['findings'] if f['ruleId']=='$rid']))" 2>/dev/null)
  [ "${c:-0}" -gt 0 ] && ok "$rid 报出（正例）" || bad "$rid 未报出"
done
M=$(node bin/cli.mjs --root tests/fixtures/pass/clean-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${M:-1}" = "0" ] && ok "合规样本 0 命中（有评估记录 + 保存三年）" || bad "误报 ${M} 条"
echo ""; echo "  【条件规则】无敏感信息的项目，敏感信息规则必须判为不适用"
A=$(node bin/cli.mjs --root tests/fixtures/absent/minimal --json 2>&1)
NA=$(echo "$A" | python3 -c "
import json,sys; d=json.load(sys.stdin)
print(','.join((d.get('stats') or {}).get('notApplicable') or []))" 2>/dev/null)
echo "$NA" | grep -q "PIPIA-SENSITIVE-NO-ASSESS" && ok "空缺样本：敏感信息规则不适用（$NA）" || bad "条件规则未生效（$NA）"
echo ""; echo "  【语义一致性】标题是 absence，实现必须是 files-lack"
python3 - <<'PY' && ok "4 条规则语义一致" || bad "有规则标题与实现相反"
import json,glob,sys
for f in glob.glob('rules/*.json'):
    r=json.load(open(f,encoding='utf-8'))
    t=(r.get('title') or '')
    if any(w in t for w in ('找不到','未发现','缺少','无任何','没有任何','不存在')):
        if r['check']['type'] != 'files-lack':
            print('语义相反:',r.get('id'),file=sys.stderr); sys.exit(1)
PY
echo ""; echo "  【溯源】每条规则必须带 source 且引法条"
python3 - <<'PY' && ok "全部规则均有 source 且引法条" || bad "有规则缺 source/法条"
import json,glob,sys
for f in glob.glob('rules/*.json'):
    r=json.load(open(f,encoding='utf-8')); s=r.get('source','')
    if not s: print('缺:',r.get('id'),file=sys.stderr); sys.exit(1)
    if '第' not in s: print('未引法条:',r.get('id'),file=sys.stderr); sys.exit(1)
PY
echo ""; echo "  ────────────────────────────────────────────────"
echo "  通过 $PASS · 失败 $FAIL"; echo ""
[ "$FAIL" -eq 0 ] || exit 1

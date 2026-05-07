# Supplementary Figure S5 Descriptive Table

This table accompanies Supplementary Figure S5, "Linguistic distribution and
audit flow." Values are computed from
`PQID/data/processed/instruction_language_audit_v1_summary.json` and
`PQID/submissions/scientific_data/LANGUAGE_AUDIT_FLOW_SUMMARY.json`. Panel B
uses square-root count scaling only for the drawn ribbon heights; the exact row
counts are reported below.

| S5 panel | audit quantity | category / flow edge | rows | share of all instruction rows | interpretation |
| --- | --- | --- | ---: | ---: | --- |
| A | input resolved language | English | 550,300 | 99.9975% | dominance of English input instructions |
| A | input resolved language | Bengali | 14 | 0.0025% | dominance of English input instructions |
| B | branch -> output scope | source-code -> code only | 9,660 | 1.7554% | first half of alluvial flow |
| B | branch -> output scope | source-code -> comments/docstrings | 8,352 | 1.5177% | first half of alluvial flow |
| B | branch -> output scope | teacher-text -> full generated text | 532,302 | 96.7270% | first half of alluvial flow |
| B | scope -> resolved class | code only -> code-only / no human text | 9,660 | 1.7554% | second half of alluvial flow |
| B | scope -> resolved class | comments/docstrings -> English text | 7,248 | 1.3171% | second half of alluvial flow |
| B | scope -> resolved class | comments/docstrings -> non-English / ambiguous tail | 1,104 | 0.2006% | second half of alluvial flow |
| B | scope -> resolved class | full generated text -> English text | 532,296 | 96.7259% | second half of alluvial flow |
| B | scope -> resolved class | full generated text -> non-English / ambiguous tail | 6 | 0.0011% | second half of alluvial flow |
| C | output audit scope | full generated text | 532,302 | 96.7270% | output text region audited for language |
| C | output audit scope | code only | 9,660 | 1.7554% | output text region audited for language |
| C | output audit scope | comments/docstrings | 8,352 | 1.5177% | output text region audited for language |
| D | resolved output tail | short fragment | 330 | 0.0600% | non-English or ambiguous resolved output label |
| D | resolved output tail | Spanish | 216 | 0.0393% | non-English or ambiguous resolved output label |
| D | resolved output tail | Japanese script | 156 | 0.0283% | non-English or ambiguous resolved output label |
| D | resolved output tail | Portuguese | 132 | 0.0240% | non-English or ambiguous resolved output label |
| D | resolved output tail | mixed | 96 | 0.0174% | non-English or ambiguous resolved output label |
| D | resolved output tail | Korean script | 90 | 0.0164% | non-English or ambiguous resolved output label |
| D | resolved output tail | French | 78 | 0.0142% | non-English or ambiguous resolved output label |
| D | resolved output tail | Cyrillic unresolved | 12 | 0.0022% | non-English or ambiguous resolved output label |
| E | output script bucket | Latin + Greek | 1,800 | 0.3271% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | mixed scripts | 174 | 0.0316% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | Hangul | 72 | 0.0131% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | no detected script | 60 | 0.0109% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | Latin + Hangul | 54 | 0.0098% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | Latin + Cyrillic | 24 | 0.0044% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | Latin + CJK | 18 | 0.0033% | non-Latin, mixed-script, or no-text output bucket |
| E | output script bucket | Latin + Arabic | 6 | 0.0011% | non-Latin, mixed-script, or no-text output bucket |

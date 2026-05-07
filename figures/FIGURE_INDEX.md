# Scientific Data Figure Index

This directory contains both manuscript-facing figure exports and auditable
Mermaid source diagrams. The `_designed.svg/png` files are the recommended main
manuscript schematics; the `.mmd` files remain source-of-record workflow
diagrams for audit and regeneration.

A parallel Calibri-styled export set is available in
`../figures_calibri/`. It is intended for Scientific Data template harmonization
and leaves the original Times-styled exports in this directory untouched.

## Main Figures

| figure | source file | manuscript role | caption draft |
| --- | --- | --- | --- |
| Figure 1 | `fig1_pqid_construction_pipeline_designed.svg/png/pdf` | Main pipeline overview | End-to-end PQID construction as an auditable evidence pipeline. The schematic emphasizes how provenance, execution, instruction generation, review, semantic audit, and release governance accumulate as row-level evidence. |
| Figure 2 | `fig2_release_stratification_designed.svg/png/pdf` | Release governance overview | Release stratification from the construction-complete instruction object to public views. The alluvial-style figure separates permissive public-open rows, license-valid rows with obligations, and internal-only material. |
| Figure 3 | `fig3_seed_generation_workflow_designed.svg/png/pdf` | OpenAI seed/paraphrase protocol | Quality-aware instruction generation as a branching flow. The figure shows how the seed-role manifest splits into source-code and teacher-text branches, expands into five paraphrases per seed, and rejoins as the canonical instruction object. |
| Figure 4 | `fig4_validation_audit_layers_designed.svg/png/pdf` | Technical validation overview | Validation and audit evidence matrix. Rows show validation layers and columns show where each layer constrains or annotates the source corpus, seed layer, paraphrase layer, and release views. |
| Figure 5 | `../plot_quantitative_figures.ipynb` -> `fig5_readiness_statistics.svg/png` | Benchmark-readiness statistics | Benchmark-readiness score distributions and check dependencies. The multi-panel figure shows n/7 and n/8 score histograms, observed versus Poisson-binomial expected n/8 scores, and the readiness-check correlation matrix. |
| Figure 6 | `../plot_quantitative_figures.ipynb` -> `fig6_semantic_paraphrase_quality.svg/png` | Semantic and paraphrase quality | Semantic consistency and paraphrase-diversity diagnostics. The multi-panel figure summarizes BERTScore F1, sentence-transformer similarity, BLEU, ROUGE-L, edit distance, and group-level pairwise BLEU with a near-duplicate threshold. |
| Figure 7 | `../plot_quantitative_figures.ipynb` -> `fig7_release_composition.svg/png` | License and release composition | License and public-release composition. The multi-panel figure summarizes internal and public release categories, split-level license-valid composition, the largest restricted-source repositories, and total row counts for internal, license-valid, public-open, and restricted views. |

## Supplementary Figures

| figure | source file | manuscript role | caption draft |
| --- | --- | --- | --- |
| Supplementary Figure S1 | `suppfig_s1_metadata_schema_architecture.mmd` | Metadata schema architecture | Metadata schema architecture for PQID. The row-level metadata object combines provenance, repository context, validation, circuit structure, benchmark readiness, metadata-design overlay, generation lineage, semantic metrics, and release metadata. |
| Supplementary Figure S2 | `suppfig_s2_license_governance_decision_tree.mmd` | License-governance details | License-governance decision tree used to translate row-level license categories into distribution-rights status, public release buckets, and release inclusion or exclusion decisions. |
| Supplementary Figure S3 | `suppfig_s3_benchmark_readiness_gate_logic.mmd` | Benchmark-readiness details | Benchmark-readiness gate logic. The n/7 profile measures validation, extraction, cleanup, size, gate, and retrieval evidence; the n/8 companion profile adds mutation-suite cleanliness and routes rows into generation, repair, robustness, or diagnosis-oriented views. |
| Supplementary Figure S4 | `../plot_quantitative_figures.ipynb` -> `suppfig_s4_acquisition_pareto_diminishing_returns.svg/png` | Acquisition Pareto and diminishing returns | Repository-level acquisition concentration and diminishing returns. The multi-panel figure shows the highest-yield source repositories, cumulative row coverage by repository rank, a descriptive log-log rank-yield decay fit, and rank-band marginal yield with Gini and Herfindahl-Hirschman concentration diagnostics. |
| Supplementary Figure S5 | `../plot_quantitative_figures.ipynb` -> `suppfig_s5_linguistic_distribution.svg/png` | Language-audit diagnostics | Linguistic distribution and audit flow. The multi-panel figure summarizes input-language dominance, output language-audit scope, a branch-to-scope-to-resolution alluvial flow, resolved non-English or ambiguous output labels, and non-Latin or mixed-script output buckets. |
| Supplementary Figure S6 | `../plot_license_behavior_panel.py` -> `suppfig_s6_license_behavior_panel.svg/png` | License-behaviour diagnostics | License-behaviour and obligation clustering. The multi-panel figure groups detected repository licenses by reuse behaviour, exact identifier frequency, release-signal matrix membership, and release-view composition. |

## Rendering Notes

Designed schematic outputs currently present:

- `fig1_pqid_construction_pipeline_designed.svg/png/pdf`
- `fig2_release_stratification_designed.svg/png/pdf`
- `fig3_seed_generation_workflow_designed.svg/png/pdf`
- `fig4_validation_audit_layers_designed.svg/png/pdf`

Rendered Mermaid audit outputs also present:

- `fig1_pqid_construction_pipeline.svg/png`
- `fig2_release_stratification.svg/png`
- `fig3_seed_generation_workflow.svg/png`
- `fig4_validation_audit_layers.svg/png`
- `suppfig_s1_metadata_schema_architecture.svg/png`
- `suppfig_s2_license_governance_decision_tree.svg/png`
- `suppfig_s3_benchmark_readiness_gate_logic.svg/png`
- `suppfig_s4_acquisition_pareto_diminishing_returns.svg/png`
- `suppfig_s6_license_behavior_panel.svg/png`

Recommended final render targets:

- SVG for manuscript drafting and clean vector review.
- PNG at journal-required resolution if the submission system does not accept SVG.
- PDF for final production if the venue accepts vector figure uploads.

Reusable local command:

```powershell
.\render_mermaid_figures.ps1
```

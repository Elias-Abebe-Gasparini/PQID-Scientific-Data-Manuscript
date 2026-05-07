# Scientific Data Submission Checklist

Last updated: 2026-04-27

## Manuscript Sections

- [x] Title
- [x] Author list
- [x] Abstract
- [x] Background & Summary
- [x] Methods
- [x] Data Records
- [x] Data Overview, optional
- [x] Technical Validation
- [x] Usage Notes
- [x] Future Directions
- [x] Conclusion
- [x] Data Availability placeholder
- [x] Code Availability placeholder
- [x] References scaffold
- [x] Author Contributions
- [ ] Competing Interests
- [ ] Acknowledgements, optional
- [ ] Funding
- [x] Ethics statement draft

## PQID-Specific Items

- [x] Recommended public release view identified: `pqid_v1_license_valid_*`
- [x] Strict permissive-only fallback identified: `pqid_v1_public_open_*`
- [x] Internal-only missing-license manifest documented
- [x] Detailed pipeline stages added to Methods
- [x] GitHub API scraping/acquisition process documented with notebook-derived acquisition routes, extraction rules, resume behavior, and strategy counts
- [x] OpenAI Responses API / Batch API seed and paraphrase generation documented with notebook-derived stages, model policy, calibration, artifacts, and final counts
- [x] Seed-generation notebook protocol documented with prompt contract, branch-specific input/output rules, Batch materialization mechanics, and A-N stage map
- [x] Progressive residual-temperature retry / anti-template closure documented with canonical paraphrase closure logic
- [x] Google Cloud L4 BERTScore backfill documented with two-pass settings, cache flow, final coverage, and diversity diagnostics
- [x] Validation, benchmark-readiness, and metadata-design overlay details added
- [x] Metadata-design notebook workflow documented with M0-M6 stages, derivation rules, field coverage, cross-tabs, split groups, near-duplicate groups, and license-governance audit
- [x] `n/7` and `n/8` benchmark-readiness mechanics explained from `0/n` to full-score rows
- [x] `0/7`-`7/7` and `0/8`-`8/8` score-interpretation tables added
- [x] Full A-G statistical readiness test battery from the analysis notebook added
- [x] Metadata schema / field-cluster table added
- [x] Release-view integrity table added
- [x] License-category and detected-license distribution artifacts generated
- [x] License distribution analysis added to public/internal split section
- [x] Stage K, K-R, L, M, and N validation layers summarized
- [x] Legacy root Scientific Data draft moved and merged
- [x] Related Work and Dataset Positioning section added
- [x] Initial reference list added
- [x] Reference list expanded to cover dataset documentation, mined-code corpora, code-generation benchmarks, quantum-code benchmarks, deduplication, and validation metrics
- [x] Hugging Face dataset URL inserted
- [x] Code repository URL inserted
- [x] Scientific Data scope alignment pass completed: public release package centered as the reusable dataset object
- [ ] Dataset DOI inserted if generated through Hugging Face/DataCite
- [ ] Exact dataset revision / release tag inserted
- [ ] Exact code repository commit / release tag inserted
- [x] Author and affiliation metadata inserted
- [ ] Corresponding-author email inserted
- [ ] Final citation format inserted
- [x] Appendix S4 descriptive tables added for concentration diagnostics, Pareto thresholds, top repositories, and rank-band marginal yield
- [x] Appendix Figure 5 descriptive tables added for readiness distributions, pass rates, Poisson-binomial expected scores, and correlation matrix
- [x] Appendix Figure 6 descriptive tables added for semantic metrics, split-level means, and paraphrase-diversity diagnostics
- [x] Appendix Figure 7 descriptive tables added for release composition, split composition, restricted repositories, and release totals
- [ ] Appendix/repository-report triage for remaining non-essential detailed tables
- [ ] Notebook outputs cleared or intentionally preserved for audit

## Figures And Tables

- [x] Pipeline figure Mermaid source created
- [x] Release-stratification figure Mermaid source created
- [x] Seed-generation workflow Mermaid source created
- [x] Validation/audit-layer Mermaid source created
- [x] Supplementary metadata-schema, license-governance, and benchmark-readiness Mermaid sources created
- [x] Figure index with draft captions created
- [x] Dedicated quantitative plotting notebook created
- [x] Plot placeholders inserted for Figures 1-7 and Supplementary Figure S4
- [x] Render Mermaid source figures 1-4 and S1-S3 to SVG/PNG
- [x] Designed manuscript-facing schematic figures 1-4 generated as SVG/PNG/PDF
- [x] Render quantitative plot figures 5-7 and Supplementary Figure S4 to SVG/PNG
- [x] Parallel Calibri-styled figure export folder generated for Scientific Data template harmonization
- [x] Acquisition Pareto and diminishing-returns diagnostic generated from raw GitHub acquisition metadata
- [ ] Render quantitative plot figures 5-7 and Supplementary Figure S4 to PDF if required by the submission system
- [ ] Confirm final venue-required figure package and file format
- [x] Data Records table
- [x] Technical Validation table
- [x] Schema field-cluster table
- [x] License distribution table
- [x] Metric-distribution and phi-matrix diagnostic tables
- [x] OpenAI generation workflow and policy tables
- [x] GCP semantic backfill execution table
- [x] Metadata-design workflow and evaluation tables
- [x] Acquisition Pareto descriptive appendix tables
- [x] Readiness, semantic-quality, and release-composition descriptive appendix tables

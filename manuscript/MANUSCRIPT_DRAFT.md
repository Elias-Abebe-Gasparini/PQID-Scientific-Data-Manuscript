# PQID: A License-Aware, Quality-Audited Instruction Dataset for Quantum Programming

Status: submission-facing working draft v0.20  
Target venue: Scientific Data  
Article type: Data Descriptor  
Last updated: 2026-04-27

Elias Abebe Gasparini<sup>1</sup> and Keeheon Lee<sup>2,*</sup>

<sup>1</sup> Department of Innovation, Yonsei University, Seoul, Republic of Korea.  
<sup>2</sup> Department of Innovation and Creative Technology Management, Yonsei
University, Seoul, Republic of Korea.  
*Correspondence should be addressed to Keeheon Lee. Email: TODO.

## Abstract

PQID is a license-aware and quality-audited public instruction dataset for
quantum programming. The recommended public release view,
`pqid_v1_license_valid_*`, contains `319,782` rows across train, validation, and
test splits, including `311,724` permissive rows, `7,356` copyleft rows, and
`702` manually reviewed other-license rows. A stricter permissive-only fallback,
`pqid_v1_public_open_*`, contains `311,724` rows. These public release files
were derived from a larger multi-stage construction object that was rebuilt
from GitHub quantum-code sources, routed into quality-aware instruction roles,
expanded through paraphrasing, and subjected to human review, model-assisted
review triage, semantic-consistency analysis, language audit, remediation, and
release stratification. The construction-complete internal object contains
`550,314` rows, comprising `91,719` seed instructions and `458,595` paraphrases,
but rows with no usable license evidence are excluded from public release. PQID
is designed to support reproducible reuse in quantum-code
generation, repair, diagnosis, and robustness research while making quality
status, provenance, release eligibility, and limitations explicit at the row
level.

## Background and Summary

Quantum programming datasets are difficult to construct responsibly because
public code repositories mix executable circuits, tutorials, partial snippets,
library internals, benchmark examples, derived artifacts, and incomplete or
license-ambiguous material. A useful research corpus must therefore do more than
collect code at scale. It must preserve provenance, validate technical content,
separate benchmark suitability from general scientific usefulness, and distinguish
internal research value from public redistributability.

PQID addresses this problem through an auditable data-construction stack. The
project first reconstructs a metadata-rich quantum-code corpus, then derives a
quality-aware instruction layer for supervised modeling tasks. The instruction
layer is not treated as a flat prompt dump. Each row carries provenance,
lineage, role, validation, language, semantic-consistency, review, remediation,
and release metadata so that downstream users can understand why a row exists,
how it was generated, whether it has been reviewed, and whether it belongs in a
public release view.

The central contribution of this Data Descriptor is the reusable public dataset
object itself: a versioned, documented, and license-filtered instruction dataset
for quantum programming, together with the scripts, notebook cells, summaries,
and manifests needed to audit how the public files were constructed.

PQID should therefore be read as a public dataset package with an accompanying
audit trail rather than as a single flat JSONL file. The upstream corpus records
`149` documented metadata fields across `17` field clusters, including
provenance, repository context, validation, benchmark-readiness diagnostics,
release governance, semantic and family annotations, and downstream
instruction-generation lineage. The current pre-seed metadata-design corpus
materializes `146` of those keys before the later seed and paraphrase stages
add generation-specific fields. This metadata architecture is what allows PQID
to separate source reconstruction, benchmark view construction, instruction
generation, and public release packaging without collapsing those decisions
into one opaque filter.

### Related Work and Dataset Positioning

PQID sits at the intersection of dataset documentation, mined-code corpora,
code-generation benchmarks, and emerging quantum-code evaluation. Its
documentation and release design are aligned with the FAIR data principles and
with dataset-documentation practices that emphasize motivation, composition,
collection process, recommended uses, and limitations [1-5]. Its GitHub-based
construction also follows a long-running caution in software-engineering
research: mined GitHub data are useful but require explicit attention to
repository activity, representativeness, provenance, and interpretation risk
[6].

General code datasets and benchmarks provide the nearest methodological
comparison class. CodeSearchNet and CodeXGLUE frame program-understanding and
code-generation tasks through reusable benchmark datasets [7,8]. HumanEval,
APPS, MBPP, DS-1000, and AlphaCode evaluate general-purpose Python,
data-science, or competition-style code generation through functional tests,
task-specific checking, or contest-style evaluation [9-13]. CodeBLEU provides a
code-specific automatic metric that combines lexical overlap with syntax and
data-flow information [14]. The Stack and StarCoder demonstrate large-scale,
governance-oriented approaches to permissively licensed source-code collection
and code-model training [15,16], while deduplication work highlights why
near-duplicate control matters for memorization and evaluation leakage [17].
PQID is complementary to these resources: it is smaller than pretraining-scale
code corpora but more domain-specific, metadata-rich, and instruction-oriented
than most general code-generation benchmarks.

Quantum-code generation benchmarks are closer in domain but differ in object
type. Qiskit HumanEval introduced a hand-curated benchmark for evaluating
large-language-model generation of executable Qiskit code [18]. More recent or
concurrent work such as QCoder Benchmark and QuanBench+ studies simulator- or
multi-framework evaluation for quantum-code generation [19,20]. PQID is not a
replacement for these executable benchmarks. Instead, it is designed as a
license-aware instruction dataset and audit object: it includes generation,
repair, diagnosis, and robustness-comparison rows, along with provenance,
license, validation, semantic, split, and release metadata. This makes PQID
useful for training, filtering, and dataset-governance analysis in addition to
benchmark construction.

| resource family | examples | primary focus | contrast with PQID |
| --- | --- | --- | --- |
| dataset documentation and governance | FAIR; Datasheets for Datasets | reusable, transparent, well-documented datasets | PQID operationalizes these ideas through row-level provenance, release buckets, and audit sidecars |
| mined-code corpora | CodeSearchNet; The Stack | code search, pretraining, or large-scale code collection | PQID is smaller but quantum-specific, instruction-oriented, and license-stratified |
| general code-generation benchmarks | HumanEval; APPS; MBPP; DS-1000 | executable or task-specific code-generation evaluation | PQID supports broader instruction roles and release governance rather than only benchmark scoring |
| quantum-code benchmarks | Qiskit HumanEval; QCoder; QuanBench+ | executable quantum-code generation evaluation | PQID is a corpus-scale instruction dataset with validation, repair, diagnosis, robustness, and metadata views |

## Methods

### Input Data and Source Tracking

PQID is a secondary dataset compiled from public quantum-programming artifacts.
The reconstruction process records source-level metadata whenever available,
including repository owner, repository name, file path, original URL, source
type, and license metadata. These fields are retained through the instruction
layer so that public release files can be audited back to their source and
license-status evidence.

Source tracking is treated as part of the dataset method rather than as an
afterthought. Rows whose upstream source or license status cannot be evaluated
are not promoted into the public release views, even when the corresponding
technical content is useful for internal analysis. This distinction is important
because PQID separates the internal construction object from the public
redistribution object.

### GitHub API Acquisition

The 2026 rebuild uses an API-first GitHub acquisition strategy rather than a
single local-clone sweep. The active acquisition notebook,
`scrape_github_unified.ipynb`, is resume-aware: processed GitHub URLs and
already-seen circuit hashes are persisted to disk so that interrupted API runs
can continue without overwriting earlier output. API credentials are resolved
from environment variables or local secret files and are not embedded in the
notebook source. Requests are issued through an authenticated GitHub session
with rate-limit backoff, a baseline request pause of `0.25` seconds, and a
search request pause of `2.5` seconds.

The baseline acquisition stage queries four complementary GitHub surfaces:

1. curated repository traversal through the Git tree and Contents APIs,
2. Qiskit-targeted GitHub Code Search queries,
3. organization-level repository enumeration for Qiskit and qiskit-community,
4. topic-level repository discovery over quantum-computing topics.

The curated input list contains `111` repository URLs and `3` gist URLs. The
baseline search pack contains `63` query strings: `26` core Qiskit circuit
queries and `37` extended queries covering primitives, simulation backends,
transpilation, circuit libraries, algorithms, machine-learning integrations,
optimization, and notebook-specific plotting or measurement examples. The
topic route uses `24` normalized topics, including Qiskit, quantum computing,
quantum circuits, quantum machine learning, VQE/QAOA, QASM, simulation, error
correction, optimization, phase estimation, Grover, and circuit-simulation
topics.

Repository traversal first resolves each repository's default branch, then uses
the recursive Git tree API to enumerate `.py` and `.ipynb` blobs. In the
baseline pass, files larger than `300,000` bytes are skipped, as are common
non-source or low-signal paths such as tests, caches, build artifacts, `docs/`,
`dist/`, `.tox/`, `node_modules`, and package metadata. File payloads are then
downloaded through the Contents API, decoded from base64, and sent to the
extractor. For Python files, the extractor identifies complete function-scoped
blocks and module-level blocks containing `QuantumCircuit` construction. For
notebooks, it scans code cells and applies the same Python extractor to each
cell. Candidate snippets are retained only when they pass a minimum token
threshold and are deduplicated by an MD5 `circuit_hash` computed over stripped
code.

Each extracted row is written incrementally as JSONL and preserves provenance
fields needed for later audit: `original_url`, `file_path`, `source`,
`language`, `circuit_hash`, Git blob `hash` where available, `start_line`,
`end_line`, `github_anchor`, `repo_owner`, `repo_name`, `scrape_date`, and
`code_lines`. Python snippets receive line-level GitHub anchors; notebook and
gist snippets retain file-level anchors when stable line anchors are not
available.

The acquisition process was then extended through append-only recall campaigns
rather than by overwriting the baseline scrape. Phase 2, labeled
`aggressive_v1`, raised the file-size ceiling to `1,000,000` bytes, allowed
documentation paths, and added a more permissive extractor keyed to additional
Qiskit idioms such as `TwoLocal`, `RealAmplitudes`, `EfficientSU2`, `QFT`,
feature maps, `NLocal`, `BlueprintCircuit`, `QuantumCircuit.from_qasm_str`,
`compose`, `append`, `decompose`, `measure_all`, `Sampler`, and `Estimator`.
It also promoted empirically high-yield repositories and added PennyLaneAI and
Quantinuum organization sweeps plus `9` expanded search queries. Phase 3,
labeled `aggressive_v2_high_yield`, raised the file-size ceiling to
`1,500,000` bytes and added trusted repository re-sweeps, `12` high-signal
expanded search queries, `5` notebook-heavy queries, and a deliberately small
gist recovery pass.

The final merge normalizes missing retrieval metadata and deduplicates baseline,
Phase 2, and Phase 3 outputs by `circuit_hash`. The canonical raw acquisition
artifact is `circuits_unified_plus_phase2_plus_phase3.jsonl`.

| acquisition layer | rows in final raw pool | main retrieval strategies |
| --- | ---: | --- |
| baseline | 21,632 | curated repositories, Code Search, organization enumeration, topic discovery |
| Phase 2 aggressive recall | 65,680 | empirical promoted repositories, expanded search, PennyLaneAI/Quantinuum org expansion, promoted repositories |
| Phase 3 high-yield recall | 4,407 | high-signal expanded search and small gist recovery |
| final merged raw pool | 91,719 | deduplicated union with normalized retrieval metadata |

The final raw pool contains `89,435` Python-derived rows and `2,284`
notebook-derived rows. Its retrieval-strategy distribution is:

| retrieval strategy | rows |
| --- | ---: |
| `empirical_promoted_repo` | 53,026 |
| `search` | 17,372 |
| `expanded_search` | 8,816 |
| `expanded_search_v2` | 4,404 |
| `org` | 4,335 |
| `topic` | 2,188 |
| `curated` | 1,448 |
| `promoted_repo` | 127 |
| `gist` | 3 |

Repository-rank concentration was also quantified from the raw acquisition
metadata as a Pareto and diminishing-returns diagnostic [26,27]. The raw pool
contains `91,719` rows from `4,550` repositories, but the first `5`
repositories account for `50%` of rows, the first `237` account for `80%`, and
the first `1,835` account for `95%`. Concentration is high by both the Gini
coefficient (`0.878`) [28] and Herfindahl-Hirschman index (`0.059`) [29], and
the descriptive log-log rank-yield fit has slope `-1.12` with `R^2 = 0.95`
[27,30]. These diagnostics make the observed acquisition pattern explicit:
after the highest-yield source repositories have been exhausted, additional
repositories contribute sharply fewer new circuit-bearing rows per unit of
acquisition effort.

**Plot placeholder: Supplementary Figure S4.** Acquisition Pareto and
diminishing-returns diagnostics will summarize the highest-yield repositories,
cumulative row coverage by repository rank, log-log rank-yield decay, and
rank-band marginal yield.

These acquisition counts are raw-corpus counts. They precede Qiskit execution
validation, `materialized_circuit` correction, benchmark-readiness scoring,
mutation-suite cleaning, metadata enrichment, and license-filtered release
export.

### Corpus Reconstruction

PQID begins from a multi-phase reconstruction of quantum-programming artifacts.
The reconstruction process collects and normalizes circuit-bearing source
material, retains repository and file-level provenance where available, and
adds metadata for validation, benchmark suitability, and release governance.
The corpus-level object remains the internal source of truth for downstream
instruction generation and audit.

The reconstruction pipeline has two historically distinct layers. The older
thesis-era layer is preserved for continuity, but the active public dataset is
the 2026 rebuild. The 2026 rebuild treats GitHub acquisition, validation,
metadata enrichment, benchmark packaging, instruction generation, and public
release filtering as separate stages so that each decision can be audited
independently.

| pipeline component | main operation | representative artifacts |
| --- | --- | --- |
| thesis baseline normalization | normalize the earlier Hugging Face PQID corpus, strip unsafe comments, add standard Qiskit imports where missing, hash and deduplicate entries | `preprocess_hf_baseline.py`; legacy `train_clean.jsonl` / `validation_clean.jsonl` inputs |
| GitHub API corpus acquisition | collect Python and notebook files containing `QuantumCircuit`-like code through GitHub Contents API traversal, Code Search, topic expansion, organization enumeration, and later aggressive rescrape passes | raw and unified circuit JSONL files under `PQID/data/processed/` |
| code-block extraction | extract candidate circuit snippets from `.py` and `.ipynb` sources while preserving repository, file path, URL, line, and blob-SHA provenance where available | `original_url`, `file_path`, `github_anchor`, `hash`, `start_line`, `end_line` |
| execution validation | execute candidate snippets in a controlled Qiskit environment [21], detect whether a real `QuantumCircuit` was materialized, classify failure modes, and export OpenQASM 3.0 when possible | `enrich_metadata.py`; `validation_status`; `materialized_circuit`; `openqasm3_code` |
| structural enrichment | compute circuit metrics, gate-set profiles, parameterization, entanglement, measurement, topology, and transpilation features for validated circuits | metadata clusters 5-11 in `SCHEMA.md` |
| benchmark-readiness scoring | compute original `n/7` benchmark readiness and cleanliness-aware `n/8` readiness with mutation-suite filtering | `benchmark_suitability_tier`; `benchmark_view_membership`; `mutation_suite_candidate` |
| metadata-design overlay | add split, release, provenance, evidence-regime, and governance fields without overwriting source validation metadata | `pqid_2026_metadata_design_overlay_v3.jsonl`; `pqid_2026_enriched_github_circuits_plus_metadata_design_v3.jsonl` |
| OpenAI API role-conditioned instruction generation | derive seed instructions from the metadata-rich corpus and expand them with lineage-preserving paraphrases through synchronous Responses API calls for pilots and Batch API jobs for full-corpus production | `seed_role_manifest_v1.jsonl`; seed/paraphrase quality-aware artifacts |
| acceptance and semantic audit | build an acceptance-gate manifest, run pilot review, remediate the rewrite tail, compute semantic and language audits | Stage K, K-R, L, and M artifacts |
| Google Cloud BERTScore backfill | compute the expensive `bert_score_f1` metric on a GPU-backed Google Cloud runtime after the local semantic first pass | `semantic_consistency_cache.jsonl`; `semantic_consistency_report.txt` |
| license-filtered release export | generate public release views from the construction-complete internal object without mutating the canonical splits | `export_license_valid_release_views.py`; Stage N notebook cells |

**Plot placeholder: Figure 1.** The PQID construction-pipeline schematic should
be inserted here from
`submissions/scientific_data/figures_calibri/fig1_pqid_construction_pipeline_designed.*`
or, if the original Times-styled set is preferred, from
`submissions/scientific_data/figures/fig1_pqid_construction_pipeline_designed.*`.
The figure summarizes source acquisition, execution and metadata validation,
instruction construction, human/semantic audit, and license-filtered release.

The current source-corpus checkpoint contains `91,719` merged circuit-level
records. Among these, `14,267` rows are validated materialized circuits and
`13,530` are validated non-zero-gate circuits in the master processable corpus.
The instruction layer is derived from the `91,719` source rows and then
expanded into `550,314` instruction rows.

### Validation and Circuit Enrichment

Validation is performed at the code-snippet level. Each candidate is executed in
a Qiskit environment and classified according to whether execution succeeds,
whether a non-placeholder `QuantumCircuit` object is actually materialized, and
whether OpenQASM 3.0 export succeeds. The `materialized_circuit` field is
important because earlier broad validation counts could be inflated by
pre-populated placeholder variables such as `qc` or `circ`; public-facing
counts therefore use materialized circuits, non-zero-gate circuits, and
explicit benchmark exports rather than raw execution-success headlines.

For validated circuits, PQID computes structural metrics such as qubit count,
classical-bit count, gate count, depth, width, gate-type histogram, number of
gate types, measurement presence, parameterization, multi-qubit-gate count,
control-flow operations, T-count, T-depth, and unconnected-qubit count. It also
adds derived flags for Clifford-only structure, Clifford+T structure, rotation
gates, entangling gates, barriers, custom gates, unitary circuits, and gate-set
diversity. These fields let users stratify rows by circuit size, expressive
power, measurement structure, and hardware-relevant complexity.

Failed or incomplete rows are not discarded silently. Validation failures are
mapped into interpretable `hallucination_type` categories such as `timeout`,
`syntax_failure`, `dependency_hallucination`, `symbol_resolution_failure`,
`non_circuit_execution`, `register_index_error`, `api_hallucination`, and
`runtime_semantic_failure`. These labels support downstream diagnosis and
repair-oriented uses of the dataset.

### Benchmark-Readiness Scoring

PQID retains two benchmark-readiness views. The original `n/7` profile records
seven checks: validated execution, high extraction confidence, no demo
scaffolding, no cleanup-candidate flag, minimum code lines, minimum gate count,
and trusted retrieval strategy. The later `n/8` profile adds a cleanliness
criterion, `non_mutation_suite_path`, so that mutation-suite or bug-stress
entries can be separated from ordinary benchmark candidates.

The two views answer different questions. The `n/7` view preserves analytical
continuity with earlier Phase 3 reports, while the `n/8` view supports cleaner
release and benchmark packaging. The current documentation-facing benchmark
headlines are `803` strict and `11,999` extended rows under `n/7`, and `415`
strict / `734` total generation-oriented rows under the cleanliness-aware
`n/8` view. The mutation-stress slice remains available for robustness and
diagnostic analysis rather than being collapsed into the clean generation
benchmark.

Mechanically, the score is a count of binary criteria satisfied by a row. Under
the original profile, a row can score from `0/7` to `7/7`; under the
cleanliness-aware profile, it can score from `0/8` to `8/8`. PQID stores not
only the total score, but also the exact passed and failed check names, so a
reviewer can reconstruct why a row is or is not benchmark-ready.

| check | profile | rationale |
| --- | --- | --- |
| `validated_execution` | `n/7`, `n/8` | code executed successfully and produced a materialized `QuantumCircuit` |
| `high_extraction_confidence` | `n/7`, `n/8` | extracted block is likely circuit-construction logic rather than unrelated tutorial or wrapper code |
| `no_demo_scaffolding` | `n/7`, `n/8` | excludes rows dominated by display, plotting, backend execution, print calls, or tutorial scaffolding |
| `no_cleanup_candidate` | `n/7`, `n/8` | excludes rows that would require later code cleanup before functioning as clean benchmark examples |
| `minimum_code_lines` | `n/7`, `n/8` | removes trivially short snippets; current strict rule uses at least five code lines |
| `minimum_gate_count` | `n/7`, `n/8` | removes empty or near-empty circuits; current strict rule uses at least two gates |
| `trusted_retrieval_strategy` | `n/7`, `n/8` | separates high-trust retrieval routes from empirically promoted sources used for recall expansion |
| `non_mutation_suite_path` | `n/8` only | separates clean benchmark candidates from mutation-suite or bug-stress paths |

The resulting score fields are:

| profile | total field | passed field | ratio field | passed-check list | failed-check list | tier field |
| --- | --- | --- | --- | --- | --- | --- |
| `n/7` | `benchmark_checks_total` | `benchmark_checks_passed` | `benchmark_checks_ratio` | `benchmark_passed_checks` | `benchmark_failed_checks` | `benchmark_suitability_tier` |
| `n/8` | `benchmark_checks_total_v2` | `benchmark_checks_passed_v2` | `benchmark_checks_ratio_v2` | `benchmark_passed_checks_v2` | `benchmark_failed_checks_v2` | `benchmark_suitability_tier_v2` |

The numerical values should be read as an additive readiness scale. A low score
does not identify a single failure mode by itself; users should inspect
`benchmark_failed_checks` or `benchmark_failed_checks_v2` for the exact cause.
The score value does, however, indicate how much of the benchmark-readiness
contract the row satisfies.

| `n/7` score | interpretation |
| --- | --- |
| `0/7` | none of the original readiness checks is satisfied; the row is not suitable for benchmark use and should be treated only as raw or diagnostic material |
| `1/7` | one readiness condition is satisfied, but the row lacks most evidence needed for validation, clean extraction, structural substance, and provenance trust |
| `2/7` | two conditions are satisfied; the row may contain useful signals but remains far from benchmark-ready |
| `3/7` | partial evidence exists, usually enough to justify diagnostic inspection but not enough for clean generation benchmarking |
| `4/7` | moderate readiness evidence; the row may be validated or structurally meaningful but still fails several quality or provenance checks |
| `5/7` | strong but incomplete readiness; the row is often useful for repair, critique, or broad validated analysis, but one or two benchmark gates remain unresolved |
| `6/7` | near-ready under the original profile; the row fails exactly one original readiness check and should be inspected through the failed-check list |
| `7/7` | all original readiness checks pass; the row is eligible for the highest-trust `n/7` strict-core benchmark class |

The `n/8` score has the same interpretation but adds explicit cleanliness
against mutation-suite paths:

| `n/8` score | interpretation |
| --- | --- |
| `0/8` | none of the readiness or cleanliness checks is satisfied; the row is not benchmark-ready |
| `1/8` | one readiness/cleanliness condition is satisfied; the row is only minimally characterized |
| `2/8` | two conditions are satisfied; the row remains primarily diagnostic or raw-corpus material |
| `3/8` | weak partial evidence; benchmark use is not appropriate without manual inspection |
| `4/8` | intermediate evidence; some technical qualities are present but multiple readiness or cleanliness gates fail |
| `5/8` | moderately strong evidence; the row may support non-benchmark analysis but is not clean benchmark material |
| `6/8` | strong but incomplete evidence; typically one or two quality, provenance, structural, or mutation-cleanliness checks remain unresolved |
| `7/8` | near-clean benchmark candidate; exactly one readiness or cleanliness check fails |
| `8/8` | all original readiness checks and the mutation-cleanliness check pass; the row is eligible for the cleanest `n/8` strict-core benchmark class |

For example, a `7/7` row that becomes `7/8` usually satisfies the original
readiness profile but fails the added mutation-cleanliness check. Such a row can
remain valuable as a mutation-stress or robustness example, but it should not be
presented as part of the clean benchmark core.

Tier labels are deterministic summaries of those checks. Under `n/7`, rows
passing all seven checks are `strict_core_candidate`. Rows passing the
execution, extraction-quality, structural-threshold, and cleanup checks but
failing only the strict provenance gate can still enter the broader
`extended_core_candidate` class. Validated rows that do not meet the benchmark
thresholds remain `validated_broad_candidate`, while unvalidated rows are
`tier2_unvalidated`. Under `n/8`, the same logic is retained but mutation-suite
or bug-stress entries are assigned to `mutation_stress_candidate` rather than
being silently mixed into the clean benchmark classes.

This is why the score is reported as a readiness metric rather than as a model
performance metric. A `7/7` or `8/8` row is not "better" in a semantic sense
than every lower-scoring row; it is better suited to a clean generation
benchmark. Lower-scoring validated rows can still be scientifically useful for
repair, critique, diagnosis, or robustness evaluation.

#### Distributional and Statistical Readiness Analysis

The readiness scores were audited as empirical distributions and as binary
check matrices, not only as row-level filters. The statistical battery is
implemented in `scrape_github_unified.ipynb` as analyses A-G and is intended to
test whether readiness scores behave like independent heterogeneous criteria or
instead reveal structured subpopulations in the corpus.

| analysis | method | question answered |
| --- | --- | --- |
| A | empirical binary-check matrix and score histogram | what are the marginal pass rates and observed `0/7`-to-`7/7` counts? |
| B | Poisson-binomial null, Pearson chi-square statistic, Monte Carlo goodness-of-fit p-value, variance ratio | can the `n/7` score distribution be explained by independent unequal-probability checks? |
| C | exact single-failure bottleneck counts and targeted phi coefficients | is the `6/7` shoulder mainly a provenance-trust bottleneck? |
| D | full pairwise phi-correlation matrix | do the seven checks form one quality axis or multiple correlated blocks? |
| E | nonparametric bootstrap over rows of the check matrix | are the overdispersion and trust-only shoulder effects stable? |
| F | companion `n/8` Poisson-binomial, transition, bottleneck, phi, and bootstrap diagnostics | how does mutation-suite cleanliness restructure the master corpus? |
| G | paired `n/7`/`n/8` histogram identity and excess-variance decomposition | why does adding cleanliness reverse the variance structure? |

The null model used for the score-distribution tests is Poisson-binomial rather
than ordinary binomial or Poisson. Each readiness check keeps its observed
marginal pass probability, but the checks are treated as independent. This is
the appropriate "Poisson-like" comparison because the criteria are intentionally
heterogeneous and bounded: execution validity, extraction confidence, gate
count, scaffolding, cleanup status, provenance trust, and mutation cleanliness
do not have equal base rates.

For the original `n/7` view, the empirical pass rates show that the checks are
far from exchangeable:

| `n/7` check | empirical pass rate |
| --- | ---: |
| `validated_execution` | 0.1556 |
| `high_extraction_confidence` | 0.1485 |
| `no_demo_scaffolding` | 0.8644 |
| `no_cleanup_candidate` | 0.8929 |
| `minimum_code_lines` | 0.9351 |
| `minimum_gate_count` | 0.1431 |
| `trusted_retrieval_strategy` | 0.4219 |

The observed score histogram sharply departs from the Poisson-binomial
expectation. The null mean equals the observed mean by construction (`3.5615`),
but the observed variance is `1.5339` versus a null variance of `0.8978`,
yielding an overdispersion ratio of `1.7085`. The Pearson chi-square statistic
is `77,498.1445`, with Monte Carlo goodness-of-fit `p = 0.000200` under
`5,000` multinomial draws from the fitted null.

| `n/7` score | observed rows | expected rows under independent-check null | observed - expected |
| --- | ---: | ---: | ---: |
| `7/7` | 803 | 92.3 | 710.7 |
| `6/7` | 11,576 | 1,741.6 | 9,834.4 |
| `5/7` | 973 | 11,809.1 | -10,836.1 |
| `4/7` | 26,942 | 33,549.1 | -6,607.1 |
| `3/7` | 39,219 | 34,257.8 | 4,961.2 |
| `2/7` | 9,153 | 9,303.1 | -150.1 |
| `1/7` | 2,980 | 935.1 | 2,044.9 |
| `0/7` | 73 | 30.8 | 42.2 |

The single-failure analysis explains the large `6/7` shoulder. Among `11,576`
rows scoring `6/7`, `11,196` fail only `trusted_retrieval_strategy`, so the
trust-only share is `0.9672`. The nonparametric bootstrap confidence interval
for this share is `[0.9639, 0.9703]`. By contrast, no `6/7` row fails only
execution validity, extraction confidence, demo-scaffolding, or cleanup; `342`
fail only `minimum_code_lines`, and `38` fail only `minimum_gate_count`. This
shows that most near-core rows are blocked by source-trust classification
rather than by broad technical weakness.

The full pairwise phi-correlation matrix confirms that the readiness checks do
not form one uniform quality dimension. The matrix below uses the following
index order: `1` validated execution, `2` high extraction confidence, `3` no
demo scaffolding, `4` no cleanup candidate, `5` minimum code lines, `6` minimum
gate count, and `7` trusted retrieval strategy.

| check | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1. `validated_execution` | 1.000 | 0.973 | 0.113 | 0.086 | -0.105 | 0.952 | -0.228 |
| 2. `high_extraction_confidence` | 0.973 | 1.000 | 0.165 | 0.145 | -0.085 | 0.936 | -0.243 |
| 3. `no_demo_scaffolding` | 0.113 | 0.165 | 1.000 | 0.875 | -0.026 | 0.118 | -0.178 |
| 4. `no_cleanup_candidate` | 0.086 | 0.145 | 0.875 | 1.000 | -0.017 | 0.094 | -0.194 |
| 5. `minimum_code_lines` | -0.105 | -0.085 | -0.026 | -0.017 | 1.000 | 0.015 | -0.121 |
| 6. `minimum_gate_count` | 0.952 | 0.936 | 0.118 | 0.094 | 0.015 | 1.000 | -0.257 |
| 7. `trusted_retrieval_strategy` | -0.228 | -0.243 | -0.178 | -0.194 | -0.121 | -0.257 | 1.000 |

The matrix has two positive blocks: an intrinsic circuit-quality block
(`validated_execution`, `high_extraction_confidence`, and
`minimum_gate_count`) and a cleanup/presentation block
(`no_demo_scaffolding` and `no_cleanup_candidate`). The provenance-trust check
is negatively associated with every other criterion. This is the matrix-level
signature of the extended-core phenomenon: many technically strong rows are
separated from the strict core because of retrieval/provenance status, not
because they fail execution or structural criteria. Bootstrap resampling over
rows of the check matrix gives a stable `n/7` overdispersion interval of
`[1.6984, 1.7188]`.

The cleanliness-aware `n/8` companion analysis is structurally different. It is
computed on the master processable corpus and adds
`non_mutation_suite_path`. Its pass-rate and score profile are:

| `n/8` check | empirical pass rate |
| --- | ---: |
| `validated_execution` | 1.0000 |
| `high_extraction_confidence` | 0.9560 |
| `no_demo_scaffolding` | 0.9560 |
| `no_cleanup_candidate` | 0.9562 |
| `minimum_code_lines` | 0.9183 |
| `minimum_gate_count` | 0.9698 |
| `trusted_retrieval_strategy` | 0.1290 |
| `non_mutation_suite_path` | 0.1545 |

| `n/8` score | observed rows |
| --- | ---: |
| `8/8` | 415 |
| `7/8` | 1,062 |
| `6/8` | 11,191 |
| `5/8` | 506 |
| `4/8` | 240 |
| `3/8` | 97 |
| `2/8` | 19 |
| `1/8` | 0 |
| `0/8` | 0 |

The `n/8` Poisson-binomial null still rejects independence, but the direction
of dispersion changes. The observed and null mean are both `6.0398`; observed
variance is `0.3949`, null variance is `0.4732`, and the overdispersion ratio
is `0.8346`, with bootstrap confidence interval `[0.8035, 0.8682]`. The
Pearson chi-square statistic is `5,562.6056`, with Monte Carlo
goodness-of-fit `p = 0.000333` under `3,000` null draws. The `7/8` shoulder is
not dominated by a single bottleneck as strongly as the `6/7` shoulder was:
`388 / 1,062` rows fail only `non_mutation_suite_path`, for a mutation-only
share of `0.3653` with bootstrap confidence interval `[0.3368, 0.3945]`.

The association of the added cleanliness criterion with the original checks
explains why the score geometry changes:

| original check compared with `non_mutation_suite_path` | phi coefficient |
| --- | ---: |
| `trusted_retrieval_strategy` | 0.6629 |
| `minimum_code_lines` | -0.5670 |
| `high_extraction_confidence` | -0.5018 |
| `no_demo_scaffolding` | -0.5018 |
| `no_cleanup_candidate` | -0.5005 |
| `minimum_gate_count` | -0.4131 |
| `validated_execution` | undefined, because execution validity is constant in the master processable corpus |

Finally, the paired comparison between `n/7` and `n/8` gives an exact algebraic
description of the transition. If `S7` is the original seven-check score and
`M` is the binary indicator for `non_mutation_suite_path`, then:

```text
S8 = S7 + M
N8(k) = N7_mutation(k) + N7_clean(k - 1)
```

The histogram identity holds exactly on the master corpus:

| `n/8` score | observed rows | mutation rows staying in same `n/7` bin | clean rows shifted from `n/7` bin |
| --- | ---: | ---: | ---: |
| `8/8` | 415 | 0 | 415 |
| `7/8` | 1,062 | 388 | 674 |
| `6/8` | 11,191 | 10,878 | 313 |
| `5/8` | 506 | 174 | 332 |
| `4/8` | 240 | 0 | 240 |
| `3/8` | 97 | 0 | 97 |
| `2/8` | 19 | 0 | 19 |
| `1/8` | 0 | 0 | 0 |
| `0/8` | 0 | 0 | 0 |

At the tier level, the same structure appears as a large mutation-stress
redirect:

| transition from `n/7` to `n/8` | rows |
| --- | ---: |
| `extended_core_candidate` -> `mutation_stress_candidate` | 10,877 |
| `validated_broad_candidate` -> `validated_broad_candidate` | 1,531 |
| `strict_core_candidate` -> `strict_core_candidate` | 415 |
| `strict_core_candidate` -> `mutation_stress_candidate` | 388 |
| `extended_core_candidate` -> `extended_core_candidate` | 319 |

Overall, `734` rows are eligible under both profiles, `11,265` are eligible
only under `n/7`, `0` are eligible only under `n/8`, and `1,531` are eligible
under neither profile. The retention rate among `n/7`-eligible rows is
`6.1172%`.

The variance reversal follows from the covariance identity:

```text
excess_variance(S7 + M) =
    excess_variance(S7) + 2 * sum_i Cov(X_i, M)
```

where `X_i` are the original seven readiness indicators. On the paired
master-corpus sample, `n/7` has observed variance `0.4898`, null variance
`0.3426`, and excess variance `0.1472`; `n/8` has observed variance `0.3949`,
null variance `0.4732`, and excess variance `-0.0783`. The change in excess
variance is `-0.2255`, exactly matching `2 * sum_i Cov(X_i,
non_mutation_suite_path) = -0.2255` up to rounding. The individual covariance
terms are:

| original check | covariance with `non_mutation_suite_path` |
| --- | ---: |
| `trusted_retrieval_strategy` | 0.080299 |
| `minimum_code_lines` | -0.056120 |
| `high_extraction_confidence` | -0.037183 |
| `no_demo_scaffolding` | -0.037183 |
| `no_cleanup_candidate` | -0.036996 |
| `minimum_gate_count` | -0.025560 |
| `validated_execution` | 0.000000 |

These statistical tests support the interpretation that PQID contains at least
three separable readiness phenomena: intrinsic circuit quality, cleanup or
presentation quality, and provenance/contamination governance. The clean `n/8`
generation benchmark is therefore small by design, while the large
mutation-stress block is retained for robustness and diagnosis rather than
misrepresented as clean generation data.

**Plot placeholder: Figure 5.** Benchmark-readiness statistics will be rendered
from `submissions/scientific_data/plot_quantitative_figures.ipynb` as
`fig5_readiness_statistics.svg` / `.png`. The planned panels show the `n/7`
score histogram, the `n/8` score histogram, observed versus Poisson-binomial
expected `n/8` scores, and the readiness-check correlation matrix.

### Metadata-Design Overlay

Before instruction generation, PQID adds an explicit metadata-design overlay.
This layer is additive: it does not replace provenance, validation, or circuit
metrics. Instead, it derives fields that make later modeling and release
decisions inspectable. Examples include `source_snapshot_timestamp`,
`source_snapshot_granularity`, `source_revision_id`,
`license_evidence_source`, `license_detection_method`,
`lineage_parent_id`, `benchmark_view_membership`,
`expected_model_stance`, `context_sufficiency_class`,
`repairability_score`, `repairability_band`, `evidence_regime`,
`split_group_id`, `near_duplicate_group_id`, `domain_slice`, `shift_axis`,
`review_trace_id`, `distribution_rights_status`,
`license_resolution_status`, `public_release_bucket`,
`permission_response_status`, and `manual_license_review_status`.

This overlay is the bridge between a corpus of code snippets and an auditable
instruction dataset. It records what a row can responsibly teach, how complete
its context is, how it should be grouped for leakage-aware splitting, and what
release constraints apply.

The metadata-design notebook,
`PQID/scripts/04_metadata_analysis/pqid_metadata_design_and_evaluation.ipynb`,
implements this layer as a staged, reproducible audit workflow rather than as a
manual spreadsheet. It wraps three scripts:
`derive_pqid_metadata_design_fields.py`,
`evaluate_pqid_metadata_design_fields.py`, and
`audit_pqid_license_governance.py`. The derivation reads
`pqid_2026_enriched_github_circuits.jsonl` and overlays fields from
`pqid_2026_master_corpus.jsonl` when the master corpus has benchmark,
semantic, family, or license information not present in the base enriched
record. It then writes two artifacts: a sidecar containing only the new
metadata-design fields and a merged corpus view in which those fields are added
under each row's `metadata` object.

| notebook stage | purpose | main artifacts |
| --- | --- | --- |
| M0 | choose smoke-test or full-corpus run mode | `METADATA_DESIGN_RUN_MODE`; optional row cap |
| M1 | derive additive metadata-design fields | `pqid_2026_metadata_design_overlay_v3.jsonl`; `pqid_2026_enriched_github_circuits_plus_metadata_design_v3.jsonl` |
| M2 | evaluate coverage, distributions, cross-tabs, split groups, and near-duplicate groups | `pqid_metadata_design_evaluation_report_v3.json`; `pqid_metadata_design_evaluation_report_v3.md` |
| M3 | preview selected evaluation tables in-notebook | field-coverage and cross-tab tables |
| M4 | inspect representative merged records | row-level samples with source, validation, benchmark, release, and governance fields |
| M5 | run release-governance audit | `pqid_license_governance_report_v3.json`; `pqid_license_governance_report_v3.md` |
| M6 | preview release buckets and top unresolved repositories | license-governance summaries |

The 27 metadata-design fields are intentionally interpretable. Snapshot fields
derive from the scrape date, Git blob hash, or URL fallback:
`source_snapshot_timestamp`, `source_snapshot_granularity`, and
`source_revision_id`. License fields separate evidence, interpretation, and
workflow state: `license_evidence_source` is `github_api` when a repository
license was available from the GitHub API and `missing` otherwise;
`license_detection_method` is `api_declared` or `unresolved`;
`distribution_rights_status` maps normalized license categories into
`redistributable_permissive`, `redistributable_copyleft`,
`review_required_other`, or `unresolved_no_license`; and
`public_release_bucket` maps those states into `public_open`,
`public_open_with_obligations`, `public_review_required`, or
`restricted_internal_only`. The companion workflow fields
`license_audit_priority`, `contact_outreach_status`,
`permission_response_status`, and `manual_license_review_status` make the
remaining governance work explicit rather than implicit.

Task and evidence fields are derived from validation and benchmark signals.
Rows with failed or absent execution validation are routed to
`expected_model_stance == diagnose`; validated strict or extended benchmark rows
are routed to `generate`; validated mutation-stress rows are routed to
`robustness_compare`; and other validated rows are routed to `repair`.
`context_sufficiency_class` distinguishes `complete_executable`,
`mutation_variant`, `demo_scaffolded`, `method_fragment`, and
`partial_implementation` rows. `repairability_score` is an integer from `0` to
`8`: it starts from a stance-dependent bonus, adds evidence for validation,
materialized circuits, and extraction confidence, adjusts for context class,
and subtracts cleanup or hallucination penalties. Scores `0`-`2` are `low`,
`3`-`5` are `medium`, and `6`-`8` are `high`.

The leakage-control fields are also deterministic. `lineage_parent_id` is built
from `content_hash`, `circuit_hash`, or a URL hash fallback. `split_group_id`
groups rows by repository file when repository owner, repository name, and file
path are available; otherwise it falls back to original URL, blob hash, or
circuit hash. `near_duplicate_group_id` normalizes code or OpenQASM by removing
comments and whitespace before hashing, so exact or near-exact code reuse can be
audited independently from repository lineage. Finally, `domain_slice` and
`shift_axis` provide analysis strata for tutorials, tests, mutation suites,
library internals, benchmark candidates, research prototypes, context
completeness shifts, mutation-status shifts, benchmark-tier shifts, repository
family shifts, and validation-status shifts.

The v3 evaluation report confirms complete coverage for all 27 added fields
over `91,719` source rows. The most important distributional checks are:

| field | values |
| --- | --- |
| `license_evidence_source` | `github_api`: 41,149; `missing`: 50,570 |
| `release_view_membership` | `public_open`: 51,954; `public_obligations`: 1,226; `public_review_required`: 117; `restricted_index`: 50,570 |
| `benchmark_view_membership` | `strict_n8`: 415; `extended_n8`: 319; `validated_broad_n8`: 1,531; `validated_master_only`: 737; `mutation_stress_n8`: 11,265; `tier2_unvalidated`: 77,452 |
| `expected_model_stance` | `generate`: 734; `repair`: 2,268; `robustness_compare`: 11,265; `diagnose`: 77,452 |
| `context_sufficiency_class` | `complete_executable`: 2,183; `mutation_variant`: 11,440; `demo_scaffolded`: 12,435; `method_fragment`: 62,356; `partial_implementation`: 3,305 |
| `repairability_band` | `high`: 14,267; `medium`: 27,267; `low`: 50,185 |
| `evidence_regime` | `clean_validated_code`: 415; `benchmark_ready_validated_code`: 319; `validated_code`: 2,093; `validated_mutation_stress`: 11,440; `partial_context`: 77,452 |
| `domain_slice` | `benchmark_candidate`: 734; `mutation_suite`: 11,440; `tutorial`: 13,561; `test_fixture`: 11,584; `library_internal`: 5,877; `research_proto`: 48,523 |

The cross-tabs provide internal-coherence checks. All `734` generation rows
come from `strict_n8` or `extended_n8`; all `11,265`
`robustness_compare` rows come from `mutation_stress_n8`; all `77,452`
diagnosis rows are unvalidated; and all public release memberships align
exactly with the derived distribution-rights states. The split-group audit
finds `46,480` unique repository-file groups, `33,666` singleton groups,
`12,814` non-singleton groups, maximum group size `194`, and average group size
`1.9733`. The near-duplicate audit finds `88,665` groups, `87,158` singleton
groups, `1,507` non-singleton groups, maximum group size `167`, and average
group size `1.0344`. These statistics are used to justify lineage-aware split
construction and to separate source-level leakage risk from code-level
duplication risk.

The license-governance audit turns the same metadata-design fields into release
decisions. It reports `51,954` redistributable permissive source rows, `1,226`
redistributable copyleft rows, `117` review-required rows, and `50,570`
unresolved no-license rows in the pre-seed source corpus. Among unresolved
no-license rows, `1,531` are validated, `497` are generation-facing, and
`1,034` are repair-facing, so the audit assigns `1,531` rows to high license
priority while leaving most unvalidated diagnosis rows at medium priority. This
is the source-corpus counterpart of the public-release split used later in the
instruction layer: release filtering is performed by explicit row-level
metadata, not by undocumented post hoc exclusion.

### Quality-Aware Instruction Generation

The instruction layer contains `91,719` seed rows and `458,595` paraphrase rows.
Seed generation is role-conditioned: source rows are routed into supervision
functions such as generation, repair, diagnosis, or robustness comparison
according to their technical evidence and benchmark-readiness metadata.
Paraphrases expand the instruction surface while preserving lineage to the seed
and source rows.

Each instruction row contains an `input`, an `output`, optional
`openqasm3_code`, and a metadata object. The metadata object carries the source
record, generation branch, prompt type, release split, license category,
release bucket, and audit fields added by later stages. This design allows users
to load the public release files directly while still retaining enough context
to filter by license class, generation mode, source repository, validation
status, or release bucket.

The routing manifest assigns each source record a role before generation.
Validated benchmark-ready rows can support direct generation. Weaker validated
or partial-context rows can support repair or explanation. Mutation-stress rows
support robustness comparison. Unvalidated or failure-bearing rows support
diagnosis rather than being treated as generation exemplars. The resulting
instruction layer therefore preserves a methodological distinction between
`generate`, `repair`, `diagnose`, and `robustness_compare` behavior.

The executable notebook of record for this stage is
`PQID/scripts/03_instruction_generation/seed_generation_quality_aware_pipeline.ipynb`.
It supersedes the older thesis-era `generate_seeds.py` /
`generate_paraphrases.py` path for the 2026 corpus rebuild. The notebook begins
with local secret discovery and an API-readiness preflight, then runs a staged
workflow that builds routing manifests, calibrates generation settings,
materializes production seeds, expands paraphrases, audits closure, and finally
refreshes the canonical split files. The notebook is intentionally
artifact-driven: each generation or retry step writes request, state, output,
error, and materialized JSONL files so that an auditor can inspect both the API
input and the canonical dataset row derived from the API output.

The seed-role manifest is generated by
`build_seed_role_manifest.py` from the enriched source corpus and the master
corpus overlay. It records the role, learning objective, expected response
mode, target supervision mode, reason for routing, source record, readiness
profile, semantic profile, and generation defaults for every source row.

| seed role | rows | expected response mode | target supervision mode |
| --- | ---: | --- | --- |
| `validation_diagnosis` | 77,452 | diagnosis | teacher text |
| `mutation_robustness` | 11,265 | diagnosis | teacher text |
| `repair_or_explanation` | 2,268 | repair | source code |
| `gold_generation` | 415 | generation | source code |
| `broad_generation` | 319 | generation | source code |

This yields `88,717` teacher-text seed rows and `3,002` source-code seed rows.
The source-code branch is used for direct Qiskit-code supervision, while the
teacher-text branch is used when the appropriate target is diagnosis,
robustness analysis, or cautious explanation rather than a clean implementation.

The seed prompt contract is fixed by `quality_aware_seed_common.py` and
`generate_seed_drafts_quality_aware.py`. Each API request receives a system
instruction requiring valid JSON with `seed_input`, `seed_quality_note`, and,
for teacher-text rows only, `teacher_output`. The request forbids metadata field
names, benchmark-score jargon, unsupported operations, and boilerplate prompt
openers. The user payload contains the assigned role, role-specific wording
instructions, the learning objective, the reason for routing, a compact
readiness profile, semantic profile, source provenance, source code, and
OpenQASM 3.0 when available. For large opaque generation examples, the prompt
adds a reminder to compress repetitive measurement structure rather than
turning the seed instruction into a gate-by-gate transcript.

The output rule differs by branch. In source-code supervision rows, the OpenAI
API drafts only the natural-language `input`; the row `output` remains the
validated or selected source-code target from the source record. In
teacher-text supervision rows, the API drafts both the `input` and the
grounded teacher-text `output`, because diagnosis and mutation-robustness rows
do not have a clean source-code target that should be presented as a canonical
solution. All seed rows receive generation metadata including
`prompt_type == base_seed_quality_aware`, `generation_model`,
`generation_date`, `seed_generation_temperature`,
`seed_generation_max_output_tokens`, `seed_role`,
`seed_learning_objective`, `seed_expected_response_mode`,
`seed_target_supervision_mode`, `seed_quality_note`,
`seed_manifest_version`, `seed_template_version`,
`seed_critique_template_version`, `seed_generation_stage`, and a new
`content_hash` over the generated input plus target output.

Generation was performed through the OpenAI API. The notebook keeps two
transport paths for the same prompt contracts. Pilot, calibration, debugging,
model-assisted review, and narrow recovery stages use synchronous Responses API
calls so prompts and outputs can be inspected immediately. Full-corpus
production uses the Batch API once routing, prompt templates, model choices,
temperature, and output schema are frozen. The Batch path changes orchestration,
cost, and resumability, but not the pedagogical role taxonomy or target schema.

The active notebook stages are:

| stage | purpose | principal artifacts |
| --- | --- | --- |
| setup / preflight | discover the local OpenAI credential, verify script availability, and confirm the planned `gpt-5.4` / temperature `0.1` seed regime | preflight notebook outputs |
| A | build the full `91,719`-row seed-role manifest from the enriched corpus plus master overlay | `seed_role_manifest_v1.jsonl`; `seed_role_manifest_v1_report.md` |
| A2 | split the manifest into source-code and teacher-text supervision branches | `seed_role_manifest_v1_source_code.jsonl`; `seed_role_manifest_v1_teacher_text.jsonl` |
| A3 | build balanced pilot manifests so calibration does not simply follow corpus order | `seed_role_manifest_v1_pilot_balanced.jsonl`; `seed_role_manifest_v1_pilot_balanced_study.jsonl` |
| B | run pilot seed-draft generation with the synchronous Responses API | `seed_drafts_quality_aware_v1.jsonl`; pilot error log |
| C-D | compare temperatures over matched pilot examples, first broadly (`0.1`, `0.3`, `0.5`) and then within the low-temperature band (`0.1`, `0.2`, `0.3`) | temperature-study JSONL outputs |
| E-F | evaluate the matched temperature outputs under the empirical/high-rigor selection rubric | `seed_temperature_empirical_evaluation_v1.json`; high-rigor selection artifacts |
| G | generate production source-code seeds, then continue with Batch API execution, missing-row recovery, and prompt-type normalization | `seed_drafts_quality_aware_source_code_v1.jsonl`; source-code batch request/state/output/error files |
| H-Cal-A/B/C | compare teacher-text model choices separately for validation-diagnosis and mutation-robustness roles, then export calibration tables | `teacher_text_model_calibration_validation_eval.json`; `teacher_text_model_calibration_mutation_eval.json` |
| H-Policy / H-Batch | freeze role-specific teacher-text model policy and run production teacher-text Batch jobs | `seed_drafts_quality_aware_teacher_text_v1.jsonl`; role-specific teacher-text batch artifacts |
| H-BR / H-Retry | shard oversized validation-diagnosis requests and close residual teacher-text gaps from downloaded or paid retry outputs | shard outputs; retry manifests; merged teacher-text seed artifact |
| I | audit full seed coverage across both supervision branches | full-corpus seed coverage notebook output |
| J | generate, retry, deduplicate, anti-template recover, and canonicalize five paraphrases per seed | `seed_paraphrases_quality_aware_source_code_v1.jsonl`; `seed_paraphrases_quality_aware_teacher_text_v1.jsonl` |
| K / K-R | build acceptance-gate manifests, run pilot review, import adjudication, and remediate the rewrite tail | acceptance-gate and remediation sidecars |
| L-M | refresh canonical splits, compute semantic/diversity metrics, and audit language scope | split files; semantic, diversity, and language reports |
| N | export license-filtered public release views from the canonical split layer | public release JSONL files and attribution manifests |

**Plot placeholder: Figure 3.** The quality-aware seed-generation workflow
schematic should be inserted here from
`submissions/scientific_data/figures_calibri/fig3_seed_generation_workflow_designed.*`
or, if the original Times-styled set is preferred, from
`submissions/scientific_data/figures/fig3_seed_generation_workflow_designed.*`.
The figure summarizes seed-role manifest construction, branch-specific
source-code and teacher-text generation, paraphrase expansion, acceptance-gate
review, and canonical split refresh.

The Batch API request builders preserve the synchronous prompt contract by
writing `/v1/responses` requests with stable `custom_id` values. For seed
generation, the custom identifier combines the source `circuit_hash` and
`seed_role`, which makes downloaded outputs joinable back to the manifest. The
materialization scripts parse the JSON response, verify required fields, skip
already materialized keys, log incomplete or malformed responses, and append
only canonical PQID rows. This is why the notebook can be resumed after
timeouts, shard boundaries, or retry waves without changing row semantics.

For source-code seed generation, the notebook first ran a pilot on balanced
manifests, then compared low-temperature settings. The empirical temperature
report contains a broad screen over `0.1`, `0.3`, and `0.5`, followed by a
low-temperature refinement over `0.1`, `0.2`, and `0.3`. The final source-code
seed setting was frozen at `gpt-5.4` with temperature `0.1` because it preserved
the strongest semantic fidelity and gate coverage while avoiding unsupported
additions.

| temperature study | temperature | matched rows | overall score mean | strict pass rate | gate coverage mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| broad screen | 0.1 | 18 | 0.9593 | 0.7222 | 0.9444 |
| broad screen | 0.3 | 18 | 0.9583 | 0.7222 | 0.9444 |
| broad screen | 0.5 | 18 | 0.9514 | 0.6667 | 0.9028 |
| low-temperature refinement | 0.1 | 18 | 0.9583 | 0.7222 | 0.9444 |
| low-temperature refinement | 0.2 | 18 | 0.9560 | 0.7222 | 0.9306 |
| low-temperature refinement | 0.3 | 18 | 0.9514 | 0.6667 | 0.9028 |

Teacher-text production uses role-specific policies derived from matched model
calibration. For `validation_diagnosis`, `gpt-5.4` outperformed
`gpt-5.4-mini` on overall score, strict pass rate, and source specificity. For
`mutation_robustness`, `gpt-5.4-mini` produced the stronger production profile,
especially on strict pass rate and lower opener concentration. The frozen
teacher-text policy was therefore:

| role | production model | temperature | calibration rationale |
| --- | --- | ---: | --- |
| `validation_diagnosis` | `gpt-5.4` | 0.1 | higher overall score (`0.6888` vs `0.6256`) and strict pass rate (`0.7627` vs `0.5000`) |
| `mutation_robustness` | `gpt-5.4-mini` | 0.1 | higher overall score (`0.6821` vs `0.6541`) and strict pass rate (`0.9500` vs `0.7193`) |

The production Batch API path is implemented with explicit request,
state, output, error, and materialization files. The request builders create
JSONL request files with stable `custom_id` values, `run_openai_batch_job.py`
uploads or resumes Batch jobs and downloads output/error files, and the
materializers convert raw Batch API responses back into canonical PQID JSONL
artifacts. Oversized request files are handled by deterministic sharding and
later merge steps rather than by changing the generation policy.

Paraphrase generation is a separate reformulation task. It uses
`gpt-5.4-mini` at temperature `0.2`, asks for five paraphrases per seed, and
preserves branch, source-seed, role, and generation metadata. The canonical
paraphrase artifacts contain exactly five paraphrases per seed after duplicate
remediation:

| branch | seed rows | paraphrase rows | coverage |
| --- | ---: | ---: | --- |
| source code | 3,002 | 15,010 | five paraphrases for each source seed |
| teacher text | 88,717 | 443,585 | five paraphrases for each teacher-text seed |
| total | 91,719 | 458,595 | five paraphrases for every seed |

The full-corpus paraphrase closure used a documented residual-recovery
procedure for stubborn cases whose outputs were valid but either truncated,
under-covered, duplicated after normalization, or too similar to already
materialized variants. This was not treated as a new corpus-wide temperature
policy. The normal paraphrase operating point remains `0.2`. Only the residual
canonical-closure tail used progressively more targeted recovery: missing-slot
retry manifests, token-safe single-paraphrase retry requests, an automated
closure loop, duplicate remediation, and finally a one-row anti-template
teacher-text tail at temperature `0.9`. That final pass changed
`paraphrase_generation_prompt_mode` to `anti_template` and forced a rotating
set of rhetorical surface forms. The final canonical rewrite removed duplicate
or overflow rows and left `0` exact normalized duplicates in both branches.

The production path is resume-safe. Seed generation is keyed by source or
manifest identifiers, and paraphrase generation is keyed by
`paraphrase_source_content_hash` and `paraphrase_variant_index`. Materialization
scripts convert downloaded Batch API outputs into the same PQID JSONL format as
the synchronous generator and write compatible error logs for audit. Earlier
thesis-era seed and paraphrase scripts used `gpt-4.1-mini`; these are preserved
as historical workflow components but are not the active quality-aware
production regime.

After seed and paraphrase closure, the unified acceptance-gate manifest
contains:

| branch | seed rows | paraphrase rows | total rows |
| --- | ---: | ---: | ---: |
| source code | 3,002 | 15,010 | 18,012 |
| teacher text | 88,717 | 443,585 | 532,302 |
| total | 91,719 | 458,595 | 550,314 |

### Human Review and Remediation

The acceptance-gate review process was conducted in staged form. A stratified
pilot sheet contained `256` rows. The final adjudicated pilot outcome was `209`
accept decisions and `47` rewrite decisions. The rewrite tail was then expanded
to include nearest same-lineage risk neighbors, producing `282` remediation
candidates: `47` core rewrite rows and `235` lineage neighbors. All `282`
remediation rows were materialized and closed with final rewrite decisions.

This design keeps the canonical construction manifest stable while preserving a
separate remediation sidecar that explains where and how the rewrite tail was
closed.

### Semantic, Diversity, and Language Validation

The instruction layer is paired with semantic-consistency metrics, including
BERTScore, and with paraphrase-diversity diagnostics. The language audit
classifies PQID as English-dominant rather than strictly English-only:
`550,300 / 550,314` instruction inputs resolve as English and `14` resolve as
Bengali, while the multilingual output tail is small and concentrated in
source-grounded comments or docstrings.

Semantic consistency is computed by
`PQID/scripts/enrich_semantic_consistency.py` after the final Stage J
canonical seed/paraphrase closure. The script compares each paraphrase input
against its source seed prompt and writes five metrics. The metric set combines
embedding-based similarity and standard text-overlap measures used in
generation evaluation [22-25]:

| metric field | method |
| --- | --- |
| `semantic_similarity_to_seed` | cosine similarity from `all-MiniLM-L6-v2` sentence-transformer embeddings |
| `bert_score_f1` | BERTScore F1 using `bert-base-uncased` |
| `bleu_score_to_seed` | sentence-level BLEU-4 with smoothing |
| `rouge_l_to_seed` | ROUGE-L F1 |
| `normalized_edit_distance` | Levenshtein distance normalized by maximum string length, with a difflib fallback |

The semantic script is chunked and resume-safe. It uses a content-derived cache
key for each paraphrase, writes incremental records to
`semantic_consistency_cache.jsonl`, and rewrites the split files from that
cache at the end. Seed rows are expected to keep semantic metric fields null,
while paraphrase rows are expected to have all five metrics populated in the
final BERT-complete run.

The BERTScore component is computationally heavier than the remaining metrics,
so Stage L used a two-pass execution framework. The first pass runs locally in
a CPU-safe configuration, computes the four lighter metrics, and leaves
`bert_score_f1` null. The second pass backfills `bert_score_f1` on a GPU-backed
Google Cloud runtime without changing the semantic method or row-level schema.

| execution phase | environment | BERTScore mode | pair chunk size | sentence batch size | BERT batch size | purpose |
| --- | --- | --- | ---: | ---: | ---: | --- |
| local first pass | local CPU workspace | skipped | 2,000 | 256 | 16 | quickly populate the non-BERT semantic layer and cache |
| cloud backfill | Google Cloud Compute Engine GPU VM, L4 preferred | enabled | 500 | 128 | 8 | fill `bert_score_f1` with smaller memory-safe chunks |
| local finalization | local workspace after cache copy-back | enabled from cache | 500 | 128 | 8 | verify cache completeness and rewrite canonical split files |

The cloud backfill protocol is documented in
`GCP_BERT_BACKFILL_STRATEGY.md` and
`GCP_BERT_BACKFILL_EXECUTION_CHECKLIST.md`. The minimum remote inputs are the
semantic script, `project_paths.py`, the three canonical split files, and the
current semantic cache. The GPU environment installs `torch`,
`sentence-transformers`, `bert-score`, `rouge-score`, `nltk`, and
`python-Levenshtein`, then runs
`PQID/scripts/enrich_semantic_consistency.py` with the following backfill
settings:

| command component | value |
| --- | --- |
| script | `PQID/scripts/enrich_semantic_consistency.py` |
| BERTScore flag | `--compute-bert-score` |
| pair chunk size | `--pair-chunk-size 500` |
| sentence-transformer batch size | `--batch-size-st 128` |
| BERTScore batch size | `--batch-size-bert 8` |

The key execution rule is that only one machine writes the BERTScore cache at a
time. After the Google Cloud L4 run, the completed
`semantic_consistency_cache.jsonl` and `semantic_consistency_report.txt` were
copied back locally. The local Stage L2 cell was then rerun in BERT mode so the
canonical `train_clean.jsonl`, `validation_clean.jsonl`, and `test_clean.jsonl`
files were rewritten from the unified completed cache.

The completed semantic report records `458,595` final cached paraphrase entries,
`91,719` seed rows, and `0` final cache misses:

| split | total rows | seed rows | paraphrase rows | paraphrase metric coverage |
| --- | ---: | ---: | ---: | --- |
| train | 440,580 | 73,430 | 367,150 | `367,150 / 367,150` for all five fields |
| validation | 55,110 | 9,185 | 45,925 | `45,925 / 45,925` for all five fields |
| test | 54,624 | 9,104 | 45,520 | `45,520 / 45,520` for all five fields |

Paraphrase diversity diagnostics are computed after semantic enrichment. The
current diversity report samples `10,000` paraphrase groups from the full
dataset and reports `30` near-duplicate groups (`0.3%`) under the
`bleu_min > 0.5` rule. Mean within-group pairwise BLEU-4 is `0.3065`, median
pairwise BLEU-4 is `0.3076`, mean worst-case BLEU-4 is `0.1132`, and mean
type-token ratio is `0.8972`. These diagnostics provide evidence that the
paraphrase layer is not simply a set of near-identical prompt copies.

The Google Cloud run is an execution optimization, not a change in semantic
methodology. The metric set, cache keys, split files, and row-level
interpretation remain the same; only the runtime used for the expensive
BERTScore component changes.

**Plot placeholder: Figure 6.** Semantic and paraphrase-quality statistics will
be rendered from `submissions/scientific_data/plot_quantitative_figures.ipynb`
as `fig6_semantic_paraphrase_quality.svg` / `.png`. The planned panels show
BERTScore F1, sentence-transformer similarity, BLEU/ROUGE/edit-distance
distributions, and group-level pairwise BLEU with the near-duplicate threshold.

### License-Filtered Release Views

PQID separates construction completeness from public release eligibility. The
full internal object remains `550,314` rows, but public release is performed
through Stage N license-filtered views.

**Plot placeholder: Figure 2.** The release-stratification schematic should be
inserted here from
`submissions/scientific_data/figures_calibri/fig2_release_stratification_designed.*`
or, if the original Times-styled set is preferred, from
`submissions/scientific_data/figures/fig2_release_stratification_designed.*`.
The figure shows how the construction-complete instruction object is separated
into the recommended license-valid public release, the stricter permissive-only
fallback, and restricted/internal-only material.

The recommended public release is `pqid_v1_license_valid_*`:

| split | rows |
| --- | ---: |
| train | 255,852 |
| validation | 32,088 |
| test | 31,842 |
| total | 319,782 |

Its license-category composition is:

| license category | rows |
| --- | ---: |
| permissive | 311,724 |
| copyleft | 7,356 |
| manually reviewed other | 702 |

The strict permissive-only fallback is `pqid_v1_public_open_*`:

| split | rows |
| --- | ---: |
| train | 249,420 |
| validation | 31,386 |
| test | 30,918 |
| total | 311,724 |

Rows with `no_license` status are not exported in public release views. A final
metadata-completeness normalization pass resolved the residual null
`license_category` values by recoding `18` already restricted gist-derived rows
as explicit `no_license` rows; no construction rows now remain in a separate
missing license-category state.

The public/internal split is driven by the observed license distribution rather
than by a fixed percentage target. Across the `550,314` construction rows,
`230,532` rows (`41.8910%`) have `license_category == no_license`, `311,724`
rows (`56.6448%`) are in the permissive category, `7,356` rows (`1.3367%`) are
copyleft, and `702` rows (`0.1276%`) are manually reviewed `other` licenses.
These are instruction-row counts; collapsing by source lineage yields `38,422`
no-license source keys, `51,954` permissive source keys, `1,226` copyleft source
keys, and `117` reviewed other-license source keys.

**License-category frequency table.** Distribution of the construction-complete
instruction layer by normalized license category and corresponding public-release
treatment.

| license class | rows | share of construction rows | unique repositories | unique source keys | release treatment |
| --- | ---: | ---: | ---: | ---: | --- |
| no_license | 230,532 | 41.8910% | 2,733 | 38,422 | excluded from public release |
| permissive | 311,724 | 56.6448% | 1,646 | 51,954 | included in `public_open` and `license_valid` |
| copyleft | 7,356 | 1.3367% | 163 | 1,226 | included in `license_valid` with obligations |
| manually reviewed other | 702 | 0.1276% | 8 | 117 | included in `license_valid` with obligations |

At the detected-license level, the largest public categories are MIT
(`175,830` rows) and Apache-2.0 (`133,302` rows). Copyleft rows are dominated by
GPL-3.0 (`5,988` rows), followed by AGPL-3.0 (`876` rows), GPL-2.0 (`474`
rows), and CC-BY-SA-4.0 (`18` rows). The manually reviewed `other` rows consist
of EPL-2.0 (`504` rows), BSD-3-Clause-Clear (`90` rows), CC-BY-4.0 (`72`
rows), and MulanPSL-2.0 (`36` rows). This distribution is what motivates two
public release views: a strict permissive-only view for users who want the
lowest-obligation package, and a broader license-valid view for users who can
preserve attribution and license-specific obligations.

**Detected-license frequency table.** Row-level distribution by detected
repository license identifier.

| license category | detected repository license | rows | share of construction rows | unique repositories |
| --- | --- | ---: | ---: | ---: |
| no_license | no detected public license | 230,532 | 41.8910% | 2,733 |
| permissive | MIT | 175,830 | 31.9508% | 936 |
| permissive | Apache-2.0 | 133,302 | 24.2229% | 641 |
| copyleft | GPL-3.0 | 5,988 | 1.0881% | 126 |
| permissive | BSD-3-Clause | 882 | 0.1603% | 30 |
| copyleft | AGPL-3.0 | 876 | 0.1592% | 26 |
| permissive | MPL-2.0 | 582 | 0.1058% | 6 |
| other | EPL-2.0 | 504 | 0.0916% | 1 |
| copyleft | GPL-2.0 | 474 | 0.0861% | 9 |
| permissive | CC0-1.0 | 438 | 0.0796% | 9 |
| permissive | Unlicense | 282 | 0.0512% | 5 |
| permissive | LGPL-3.0 | 198 | 0.0360% | 7 |
| permissive | BSD-2-Clause | 114 | 0.0207% | 4 |
| other | BSD-3-Clause-Clear | 90 | 0.0164% | 2 |
| other | CC-BY-4.0 | 72 | 0.0131% | 4 |
| permissive | EUPL-1.2 | 48 | 0.0087% | 3 |
| permissive | LGPL-2.1 | 48 | 0.0087% | 5 |
| other | MulanPSL-2.0 | 36 | 0.0065% | 1 |
| copyleft | CC-BY-SA-4.0 | 18 | 0.0033% | 2 |

Supplementary Figure S6 complements this identifier-level table by clustering
the detected licenses by behavioural family rather than by normalized release
category alone. The panel separates low-obligation permissive licenses,
weak file/library reciprocal licenses, strong or network reciprocal licenses,
attribution/content licenses, and rows with no detected public license. This
view is descriptive and does not override row-level release metadata, but it
helps users understand which kinds of reuse obligations are concentrated in the
license-valid and public-open views.

**Plot placeholder: Supplementary Figure S6.** License-behaviour and obligation
clustering will be rendered from
`submissions/scientific_data/plot_license_behavior_panel.py` as
`figures/suppfig_s6_license_behavior_panel.svg` / `.png`. The planned panels
show behavioural-family row mass, exact detected-license frequencies, a
release-signal matrix, and release-view composition by behavioural family.

The release export script adds release metadata to exported rows, including
`release_export_version`, `release_export_profile`, `release_split`,
`release_filter_basis`, `public_release_bucket`,
`distribution_rights_status`, and `license_resolution_status`. For the `702`
manually reviewed `other`-license rows, it also records the manual-review
version and an obligation note indicating that attribution and license-specific
requirements should be preserved.

**Plot placeholder: Figure 7.** License and release-composition statistics will
be rendered from `submissions/scientific_data/plot_quantitative_figures.ipynb`
as `fig7_release_composition.svg` / `.png`. The planned panels show
construction-to-release composition, split-level license-valid composition, top
restricted-source repositories, and total row counts for the internal,
license-valid, public-open, and restricted views.

## Data Records

Each public JSONL row has four top-level fields:

| field | type | description |
| --- | --- | --- |
| `input` | string | natural-language instruction |
| `output` | string | target response; either source-code-supervised Qiskit code or teacher-text diagnosis / repair / robustness analysis |
| `openqasm3_code` | string or null | OpenQASM 3.0 representation exported from a validated Qiskit circuit when available |
| `metadata` | object | provenance, validation, generation, review, semantic, language, and release annotations |

The public package should include the recommended `license_valid` release view
and its attribution manifest:

- `PQID/data/processed/release_views/pqid_v1_license_valid_train.jsonl`
- `PQID/data/processed/release_views/pqid_v1_license_valid_validation.jsonl`
- `PQID/data/processed/release_views/pqid_v1_license_valid_test.jsonl`
- `PQID/data/processed/release_views/pqid_v1_license_valid_summary.json`
- `PQID/data/processed/release_views/pqid_v1_license_valid_summary.md`
- `PQID/data/processed/release_views/pqid_v1_license_valid_attribution_manifest.csv`

| file | role | rows |
| --- | --- | ---: |
| `pqid_v1_license_valid_train.jsonl` | recommended public train split | 255,852 |
| `pqid_v1_license_valid_validation.jsonl` | recommended public validation split | 32,088 |
| `pqid_v1_license_valid_test.jsonl` | recommended public test split | 31,842 |
| `pqid_v1_license_valid_summary.json` | machine-readable release summary | 1 summary object |
| `pqid_v1_license_valid_summary.md` | human-readable release summary | 1 report |
| `pqid_v1_license_valid_attribution_manifest.csv` | source and license attribution manifest | one row per attribution entry |

The strict permissive-only fallback should also be preserved:

- `PQID/data/processed/release_views/pqid_v1_public_open_train.jsonl`
- `PQID/data/processed/release_views/pqid_v1_public_open_validation.jsonl`
- `PQID/data/processed/release_views/pqid_v1_public_open_test.jsonl`
- `PQID/data/processed/release_views/pqid_v1_public_open_summary.json`
- `PQID/data/processed/release_views/pqid_v1_public_open_summary.md`
- `PQID/data/processed/release_views/pqid_v1_public_open_attribution_manifest.csv`

| file | role | rows |
| --- | --- | ---: |
| `pqid_v1_public_open_train.jsonl` | permissive-only train split | 249,420 |
| `pqid_v1_public_open_validation.jsonl` | permissive-only validation split | 31,386 |
| `pqid_v1_public_open_test.jsonl` | permissive-only test split | 30,918 |
| `pqid_v1_public_open_summary.json` | machine-readable strict release summary | 1 summary object |
| `pqid_v1_public_open_summary.md` | human-readable strict release summary | 1 report |
| `pqid_v1_public_open_attribution_manifest.csv` | permissive-only attribution manifest | one row per attribution entry |

The release exporter also writes an empty missing-license audit manifest as a
regression check; after the final metadata-completeness normalization pass it
contains `0` rows and is not part of the public training data:

- `PQID/data/processed/release_views/pqid_v1_missing_license_internal_only.jsonl`
- `PQID/data/processed/release_views/pqid_v1_missing_license_internal_only_summary.json`

The Scientific Data submission package also includes generated license
distribution artifacts:

- `PQID/submissions/scientific_data/LICENSE_DISTRIBUTION_SUMMARY.json`
- `PQID/submissions/scientific_data/LICENSE_DISTRIBUTION_SUMMARY.md`
- `PQID/submissions/scientific_data/LICENSE_CATEGORY_DISTRIBUTION.csv`
- `PQID/submissions/scientific_data/REPO_LICENSE_DISTRIBUTION.csv`

These tables are generated by
`PQID/submissions/scientific_data/analyze_license_distribution.py` from the
canonical splits and release-view summaries.

### Metadata Schema

The full schema documents `149` metadata fields across `17` documented cluster
rows. The active pre-seed metadata-design v3 corpus materializes `146` metadata
keys because generation-only seed and paraphrase fields appear later on
instruction artifacts rather than on the pre-seed merged corpus view.

| cluster | fields | populated by | purpose |
| --- | ---: | --- | --- |
| provenance | 18 | scraper / preprocessor | source URL, file path, repository, line anchors, blob hash, scrape date, retrieval mode, and deduplication hashes |
| instruction generation | 10 base fields plus quality-aware seed/paraphrase fields | generation scripts and metadata patching | prompt type, generation model/date, paraphrase lineage, token counts, seed role, response mode, and template versions |
| repository context | 2 | repository-topic enrichment | GitHub topics and organization-account flag |
| execution / validation | 14 | `enrich_metadata.py` | execution status, materialized circuit, OpenQASM export status, Qiskit version, deprecated API patterns, failure class, and extraction-quality signals |
| benchmark cleaning / corpus-role diagnostics | 2 | benchmark filtering scripts | mutation-suite flags and benchmark-cleaning flags |
| core circuit metrics | 17 | `enrich_metadata.py` | qubits, clbits, registers, gates, depth, width, gate histograms, measurements, parameters, control flow, T-count, and unconnected qubits |
| gate-set profile flags | 8 | `enrich_metadata.py` | Clifford-only, Clifford+T, rotations, entangling gates, barriers, custom gates, unitary status, and gate-set diversity |
| XAI complexity indicators | 3 | `enrich_metadata.py` | circuit expressiveness, size class, and benchmark difficulty |
| entanglement features | 3 | `enrich_metadata.py` | two-qubit gate count, entangling-gate ratio, and entanglement depth |
| parameterization features | 3 | `enrich_metadata.py` | parameter count, parameter density, and parameter reuse |
| measurement / output structure | 5 | `enrich_metadata.py` | measurement count, measured qubits, classical registers, mid-circuit measurement, and output structure |
| topology / interaction graph | 4 | `enrich_metadata.py` | graph edges, connected components, graph density, and maximum qubit degree |
| transpilation metrics | 8 | `enrich_metadata.py` | transpilation-derived structural metrics and backend-normalized indicators |
| license fields | 2 | repository-license enrichment | detected repository license and normalized license category |
| circuit family fields | 2 | circuit-family enrichment | circuit family and semantic intent |
| semantic consistency metrics | 5 | semantic-consistency enrichment | seed/paraphrase similarity scores including BERTScore, BLEU, ROUGE-L, and edit distance |
| metadata-design overlay | 27 | metadata-design notebook and scripts | release, benchmark, evidence-regime, split, lineage, and governance fields |

Review, remediation, and language-audit outputs are stored as sidecar layers
keyed by `instruction_key`. They are intentionally tracked separately from the
`149` canonical metadata-field count unless promoted into row metadata in a
future version. This keeps the release JSONL files compact while preserving
review evidence in auditable artifacts.

Key schema fields for ordinary reuse are:

| use case | fields |
| --- | --- |
| source attribution | `repo_owner`, `repo_name`, `file_path`, `original_url`, `github_anchor`, `hash`, `source_revision_id` |
| leakage-aware grouping | `split_group_id`, `split_group_source`, `near_duplicate_group_id`, `lineage_parent_id` |
| code validity | `validation_status`, `materialized_circuit`, `circuit_stats_available`, `openqasm3_export_successful`, `hallucination_type` |
| circuit filtering | `num_qubits`, `gate_count`, `circuit_depth`, `gate_types`, `has_measurement`, `is_parameterized`, `benchmark_difficulty` |
| task filtering | `expected_model_stance`, `context_sufficiency_class`, `repairability_band`, `evidence_regime`, `benchmark_view_membership` |
| release filtering | `repo_license`, `license_category`, `public_release_bucket`, `distribution_rights_status`, `license_resolution_status`, `release_export_profile` |

## Data Overview

PQID contains two linked data layers. The first is the reconstructed
quantum-code corpus, which contains `91,719` merged circuit-level records and
supports benchmark-facing views such as `strict_n8`, `extended_n8`,
`validated_broad_n8`, `validated_master_only`, `mutation_stress_n8`, and
`tier2_unvalidated`. The second is the quality-aware instruction layer derived
from that corpus, which contains `550,314` instruction rows.

The instruction layer preserves the behavioral distinction induced by the
upstream metadata. At the corpus-design level, rows may support generation,
repair, diagnosis, or robustness-comparison behavior rather than being treated
as interchangeable examples. This distinction is useful for downstream users
who want to filter the public release view by intended task or by evidence
strength.

| layer | primary role | headline count |
| --- | --- | ---: |
| reconstructed source corpus | source and benchmark infrastructure | 91,719 records |
| seed instruction layer | role-conditioned seed instructions | 91,719 rows |
| paraphrase layer | lineage-preserving instruction variants | 458,595 rows |
| internal instruction object | complete construction/audit object | 550,314 rows |
| recommended public release | license-valid public instruction package | 319,782 rows |
| strict public fallback | permissive-only instruction package | 311,724 rows |

## Technical Validation

PQID's validation is multi-layered:

1. Construction closure verifies that all `91,719` seeds and `458,595`
   paraphrases are represented in the canonical instruction layer.
2. Acceptance-gate pilot review provides human review evidence over a stratified
   `256`-row sample.
3. K-R remediation closes the non-trivial rewrite tail and same-lineage risk
   neighbors with `282 / 282` materialized remediation results.
4. Metadata-design evaluation verifies full coverage and coherence for the 27
   additive release, split, task-routing, and governance fields.
5. Semantic-consistency metrics and paraphrase-diversity diagnostics audit the
   paraphrase layer.
6. Language audit documents the English-dominant language profile and small
   multilingual output tail.
7. Stage N release-view integrity checks verify that no `no_license` rows
   appear in public release files and that no residual missing license-category
   state remains in the canonical construction splits.

| validation layer | artifact | main check | outcome |
| --- | --- | --- | --- |
| Stage J closure | `instruction_acceptance_gate_manifest_v1.jsonl` | all seeds and paraphrases represented | `550,314` rows |
| Stage K pilot | `instruction_acceptance_gate_pilot_review_sheet_v1.csv` | stratified human review | `209` accept / `47` rewrite |
| Stage K-R remediation | `instruction_acceptance_gate_remediation_outputs_v1_summary.json` | rewrite-tail and lineage-neighbor closure | `282 / 282` materialized rewrites |
| metadata-design evaluation | `pqid_metadata_design_evaluation_report_v3.json` and Markdown report | coverage, distributions, cross-tabs, split groups, near-duplicate groups | all 27 added fields present for `91,719` rows |
| license-governance audit | `pqid_license_governance_report_v3.json` and Markdown report | release buckets, unresolved-license concentration, audit priority | `41,032` redistributable source rows; `117` review-required source rows; `50,570` restricted source rows |
| Stage L semantic audit | `semantic_consistency_cache.jsonl` and report | paraphrase consistency metrics including BERTScore | completed |
| Stage M language audit | `instruction_language_audit_v1_summary.json` | input/output language scope | English-dominant, with documented tail |
| Stage N release audit | release-view summaries and notebook cells | public release excludes no-license rows; missing license-category count is zero | passed |

**Plot placeholder: Figure 4.** The validation and audit-layer schematic should
be inserted here from
`submissions/scientific_data/figures_calibri/fig4_validation_audit_layers_designed.*`
or, if the original Times-styled set is preferred, from
`submissions/scientific_data/figures/fig4_validation_audit_layers_designed.*`.
The figure summarizes how validation, metadata-design evaluation, acceptance
review, semantic and language audits, and release-view checks constrain the
public dataset package.

### Release-View Integrity Checks

Stage N regenerates both public release profiles from the canonical train,
validation, and test construction splits and then recounts the resulting JSONL
files. The integrity check asserts that `pqid_v1_public_open_*` contains only
`license_category == permissive`, while `pqid_v1_license_valid_*` contains only
`permissive`, `copyleft`, and manually reviewed `other` rows. It also asserts
that the exported row totals match the machine-readable summaries.

The most recent file-level verification produced:

| release view | train | validation | test | total | exported categories |
| --- | ---: | ---: | ---: | ---: | --- |
| `pqid_v1_public_open_*` | 249,420 | 31,386 | 30,918 | 311,724 | `permissive: 311,724` |
| `pqid_v1_license_valid_*` | 255,852 | 32,088 | 31,842 | 319,782 | `permissive: 311,724`; `copyleft: 7,356`; `other: 702` |

The missing-license audit manifest now contains `0` rows after the final
metadata-completeness normalization pass. No `no_license` rows are present in
either public release view.

### Acceptance-Gate And Remediation Checks

The acceptance-gate layer audits the generated instruction surface rather than
the source-code extraction alone. The `256`-row pilot was stratified across
observed review strata, with forced anti-template tail cases included to stress
the weakest generation patterns. The final human adjudication was `209` accept
and `47` rewrite. The rewrite set was expanded to same-lineage neighbors so
that localized failure patterns were not repaired in isolation. The resulting
K-R candidate file contained `282` rows: `47` core rewrite rows and `235`
lineage neighbors. The remediation result summary reports `282` result rows,
`0` missing outputs, and `2` manual closeout overrides.

### Semantic And Language Checks

Semantic checks are used as audit aids, not as automatic acceptance labels.
Paraphrase rows are compared against their seed lineage using metrics such as
BERTScore, BLEU, ROUGE-L, and normalized edit distance. Diversity diagnostics
provide additional evidence that the paraphrase layer is not merely a repeated
surface template. The language audit resolves `550,300 / 550,314` instruction
inputs as English and `14` as Bengali; multilingual output traces are
documented separately and concentrated in source-grounded comments, docstrings,
or code-only outputs.

## Usage Notes

Users should treat `pqid_v1_license_valid_*` as the recommended public dataset
when they can preserve attribution and license-specific obligations. Users who
need a stricter permissive-only package should use `pqid_v1_public_open_*`.

The full `550,314`-row construction object should not be treated as the public
release package. It is the internal object of record used for audit,
methodological reporting, and reproducibility of the construction pipeline.

PQID is best suited for reuse in quantum-code instruction following,
programming assistance, repair, diagnosis, and robustness research. It should
not be described as a general natural-language dataset, nor as a legally
unrestricted scrape of public code. The present Data Descriptor documents the
dataset and its technical validation; it does not report model-training results
or test a model-performance hypothesis.

Recommended loading procedure:

1. Use `pqid_v1_license_valid_train.jsonl`,
   `pqid_v1_license_valid_validation.jsonl`, and
   `pqid_v1_license_valid_test.jsonl` for the broad public dataset.
2. Preserve the accompanying attribution manifest with any redistributed copy.
3. Filter `metadata.public_release_bucket == "public_open"` when an
   obligation-free permissive subset is required.
4. Treat `metadata.public_release_bucket == "public_open_with_obligations"` as
   redistributable only with the corresponding attribution and
   license-specific obligations.
5. Do not merge internal-only or no-license material into public training
   releases.

## Limitations

PQID remains constrained by upstream provenance and licensing. Some technically
useful material is excluded from public release because repository licenses are
absent, unclear, or not independently verifiable. During final release
preparation, the maintainer of `runtsang/Q-Bridge` added a root MIT license
file, which reclassified Q-Bridge-derived rows as repository-level permissive
material. This resolves the release decision for the Q-Bridge repository
contents used by PQID, but the public Q-Bridge artifacts still do not expose the
upstream seed-to-repository mapping needed to independently audit any embedded
third-party provenance. This is a limitation of public release transparency
rather than a claim that the underlying artifacts are necessarily unusable in
every legal or institutional context.

The dataset is English-dominant and quantum-programming-specific. It is not
intended to evaluate broad multilingual instruction following or general-purpose
software engineering.

## Future Directions

PQID creates several immediate directions for follow-on work. The first is
benchmarking. The present Data Descriptor focuses on dataset construction,
validation, and release governance rather than on model performance. A natural
next step is to train and evaluate quantum-code assistants on the public release
views and to compare them against general code-generation baselines, existing
quantum-code benchmarks, and ablated PQID variants. Such experiments should
separate generation quality, executable-circuit validity, repair behavior,
diagnostic explanation quality, and robustness to noisy or underspecified
prompts.

A second direction is longitudinal release maintenance. The current public
release is intentionally conservative: rows without usable license evidence are
preserved internally but withheld from redistribution. Future versions can
expand the public view if missing repository metadata, upstream ownership, or
license status can be resolved. Conversely, the same infrastructure can support
removal, quarantine, or reclassification if future audits identify provenance
or licensing problems. This makes PQID suitable for versioned dataset
governance rather than one-time publication.

A third direction is broader quantum-software coverage. PQID is centered on
Qiskit and Python because that ecosystem offered the strongest combination of
public code availability, validation tooling, and circuit materialization
support during construction. Future releases could extend the same pipeline to
other quantum frameworks and languages, provided that equivalent provenance,
license, execution, and schema-audit layers can be maintained.

Finally, the metadata released with PQID may support secondary research on data
governance. The construction process documents the practical cost of downstream
due diligence when public artifacts preserve seed-file references but not
complete upstream repository-owner mappings. Such work is outside the central
scope of this Data Descriptor, but the release metadata and audit summaries can
support future studies of provenance-aware dataset publication and automated
license-evidence capture.

## Conclusion

PQID is a license-aware, quality-audited public instruction dataset for quantum
programming. Its main contribution is the reusable release package and the
auditable construction stack that links source acquisition, metadata design,
validation, instruction generation, semantic checks, human review, remediation,
and release stratification.

The resulting public release views provide a practical dataset for quantum-code
instruction-following research while preserving a strict distinction between
redistributable material and internal-only audit material. By making quality
status, provenance, release eligibility, and known limitations explicit at the
row level, PQID is intended to support transparent reuse in quantum programming
research.

## Data Availability

The dataset is hosted on Hugging Face at
https://huggingface.co/datasets/Elias-Abebe-Gasparini/PQID. The public dataset
object described for reuse in this Data Descriptor is the
`pqid_v1_license_valid_*` release view plus its summary and attribution
manifest, with `pqid_v1_public_open_*` provided as a strict permissive-only
fallback. These public release files are intended to be available from the
repository without access controls. The construction-complete internal object
of record is retained for audit and is not part of the public release package.

The final dataset citation should include the Hugging Face dataset URL, release
version or commit revision, access date, and dataset DOI if a Hugging Face DOI
is generated for the release. The journal article DOI will be assigned by the
publisher and is distinct from any dataset DOI.

## Code Availability

The code used to regenerate the release views is staged in the PQID project
repository at https://github.com/Elias-Abebe-Gasparini/PQID-Dataset. The key
script is
`PQID/scripts/export_license_valid_release_views.py`, and the notebook-auditable
release workflow is Stage N of
`PQID/scripts/03_instruction_generation/seed_generation_quality_aware_pipeline.ipynb`.
The license-distribution tables used in this manuscript are generated by
`PQID/submissions/scientific_data/analyze_license_distribution.py`.
The final submission should identify the exact repository commit or release tag
used to generate the submitted dataset files.

## Appendix: Supplementary Descriptive Tables

The following descriptive tables provide the numeric audit trail for
Supplementary Figure S4. They are computed from
`pqid_2026_raw_github_circuits.jsonl`, the raw GitHub acquisition object used
before execution validation, metadata enrichment, instruction generation, and
license-filtered export.

**Appendix Table A1. Repository-level concentration diagnostics.**

| diagnostic | value | interpretation |
| --- | ---: | --- |
| raw acquisition rows | 91,719 | circuit-bearing rows before downstream validation and release filtering |
| unique source repositories | 4,550 | repositories represented in the raw acquisition metadata |
| Gini coefficient | 0.8782 | high inequality in row yield across repositories |
| Herfindahl-Hirschman index | 0.0594 | concentration of row yield across repository shares |
| log-log rank-yield slope | -1.1223 | descriptive decay rate of repository yield by rank |
| log-log rank-yield `R^2` | 0.9510 | goodness of fit for the descriptive rank-yield line |

**Appendix Table A2. Pareto coverage thresholds by repository rank.**

| row-coverage threshold | repositories required | cumulative rows | observed cumulative coverage |
| ---: | ---: | ---: | ---: |
| 50% | 5 | 46,175 | 50.34% |
| 80% | 237 | 73,388 | 80.01% |
| 90% | 967 | 82,550 | 90.00% |
| 95% | 1,835 | 87,137 | 95.00% |
| 99% | 3,633 | 90,802 | 99.00% |

**Appendix Table A3. Highest-yield source repositories in the raw acquisition
object.**

| rank | repository | rows | row share | cumulative share |
| ---: | --- | ---: | ---: | ---: |
| 1 | `runtsang/Q-Bridge` | 12,148 | 13.24% | 13.24% |
| 2 | `Ahmik-Virani/Differentiating-Quantum-Bug-From-Noise-Statistical-Approach` | 11,549 | 12.59% | 25.84% |
| 3 | `backordinary/QDP-FSL` | 8,959 | 9.77% | 35.60% |
| 4 | `wjy99-c/QDiff` | 8,174 | 8.91% | 44.52% |
| 5 | `AayushSarkar/Qiskit-Experiment-Hub` | 5,345 | 5.83% | 50.34% |
| 6 | `lockephi/Allentown-L104-Node` | 4,979 | 5.43% | 55.77% |
| 7 | `Ali-hey-0/Qiskit` | 2,732 | 2.98% | 58.75% |
| 8 | `sethuquantum/LearnQuantum` | 2,277 | 2.48% | 61.23% |
| 9 | `HAMEEMM/qiskit` | 987 | 1.08% | 62.31% |
| 10 | `Arka221B/Qiskit_terra` | 980 | 1.07% | 63.38% |
| 11 | `PennyLaneAI/pennylane` | 867 | 0.95% | 64.32% |
| 12 | `dereklin1205/COMM_LAB_Final` | 702 | 0.77% | 65.09% |
| 13 | `Qiskit/qiskit` | 665 | 0.73% | 65.82% |
| 14 | `Qiskit/platypus` | 491 | 0.54% | 66.35% |
| 15 | `Qiskit/documentation` | 470 | 0.51% | 66.86% |

**Appendix Table A4. Rank-band marginal yield.**

| repository-rank band | repositories | rows | row share | mean rows per repository | median rows per repository | min-max rows |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1-5 | 5 | 46,175 | 50.34% | 9,235.00 | 8,959 | 5,345-12,148 |
| 6-25 | 20 | 17,503 | 19.08% | 875.15 | 382 | 174-4,979 |
| 26-100 | 75 | 5,427 | 5.92% | 72.36 | 66 | 46-157 |
| 101-500 | 400 | 8,781 | 9.57% | 21.95 | 19 | 13-46 |
| 501-1,000 | 500 | 4,898 | 5.34% | 9.80 | 10 | 7-13 |
| 1,001-4,550 | 3,550 | 8,935 | 9.74% | 2.52 | 2 | 1-7 |

The following tables provide the panel-level values behind Figure 5. These
tables are computed from `pqid_2026_master_corpus.jsonl`, matching the
quantitative plotting notebook. The earlier Methods section separately reports
the full raw-corpus `n/7` analysis.

**Appendix Table A5. Figure 5 readiness-score distributions.**

| score | `n/7` rows | `n/7` share | `n/8` rows | `n/8` share |
| ---: | ---: | ---: | ---: | ---: |
| 0 | 0 | 0.00% | 0 | 0.00% |
| 1 | 19 | 0.14% | 0 | 0.00% |
| 2 | 97 | 0.72% | 19 | 0.14% |
| 3 | 240 | 1.77% | 97 | 0.72% |
| 4 | 332 | 2.45% | 240 | 1.77% |
| 5 | 487 | 3.60% | 506 | 3.74% |
| 6 | 11,552 | 85.38% | 11,191 | 82.71% |
| 7 | 803 | 5.93% | 1,062 | 7.85% |
| 8 | NA | NA | 415 | 3.07% |

**Appendix Table A6. Figure 5 `n/8` check pass rates.**

| `n/8` check | passing rows | pass rate |
| --- | ---: | ---: |
| `validated_execution` | 13,530 | 100.00% |
| `high_extraction_confidence` | 12,935 | 95.60% |
| `no_demo_scaffolding` | 12,935 | 95.60% |
| `no_cleanup_candidate` | 12,938 | 95.62% |
| `minimum_code_lines` | 12,425 | 91.83% |
| `minimum_gate_count` | 13,121 | 96.98% |
| `trusted_retrieval_strategy` | 1,745 | 12.90% |
| `non_mutation_suite_path` | 2,090 | 15.45% |

**Appendix Table A7. Figure 5 observed versus Poisson-binomial expected `n/8`
scores.**

| `n/8` score | observed rows | expected rows under independent-check null | observed - expected |
| ---: | ---: | ---: | ---: |
| 0 | 0 | 0.0 | 0.0 |
| 1 | 0 | 0.0 | -0.0 |
| 2 | 19 | 0.2 | 18.8 |
| 3 | 97 | 9.7 | 87.3 |
| 4 | 240 | 202.1 | 37.9 |
| 5 | 506 | 2,066.0 | -1,560.0 |
| 6 | 11,191 | 8,422.8 | 2,768.2 |
| 7 | 1,062 | 2,619.5 | -1,557.5 |
| 8 | 415 | 209.8 | 205.2 |

**Appendix Table A8. Figure 5 `n/8` readiness-check correlation matrix.**

`valid` is constant in the plotted master corpus, so its correlations are
undefined.

| check | valid | extract | no-demo | clean | lines | gates | trusted | non-mut |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| valid | NA | NA | NA | NA | NA | NA | NA | NA |
| extract | NA | 1.0000 | 1.0000 | 0.9974 | 0.1848 | 0.2085 | -0.3552 | -0.5018 |
| no-demo | NA | 1.0000 | 1.0000 | 0.9974 | 0.1848 | 0.2085 | -0.3552 | -0.5018 |
| clean | NA | 0.9974 | 0.9974 | 1.0000 | 0.1816 | 0.2091 | -0.3554 | -0.5005 |
| lines | NA | 0.1848 | 0.1848 | 0.1816 | 1.0000 | 0.5306 | -0.4296 | -0.5670 |
| gates | NA | 0.2085 | 0.2085 | 0.2091 | 0.5306 | 1.0000 | -0.3004 | -0.4131 |
| trusted | NA | -0.3552 | -0.3552 | -0.3554 | -0.4296 | -0.3004 | 1.0000 | 0.6629 |
| non-mut | NA | -0.5018 | -0.5018 | -0.5005 | -0.5670 | -0.4131 | 0.6629 | 1.0000 |

The following tables provide the panel-level values behind Figure 6. They are
computed from `train_clean.jsonl`, `validation_clean.jsonl`,
`test_clean.jsonl`, and `paraphrase_diversity.jsonl`.

**Appendix Table A9. Figure 6 semantic-metric descriptive statistics.**

| metric | n | mean | sd | p05 | p25 | median | p75 | p95 | min | max |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `bert_score_f1` | 458,595 | 0.8819 | 0.0578 | 0.7687 | 0.8510 | 0.8923 | 0.9241 | 0.9570 | 0.5380 | 0.9991 |
| `semantic_similarity_to_seed` | 458,595 | 0.9252 | 0.0661 | 0.7956 | 0.9085 | 0.9463 | 0.9666 | 0.9820 | 0.2244 | 0.9998 |
| `bleu_score_to_seed` | 458,595 | 0.4116 | 0.1737 | 0.1192 | 0.2874 | 0.4143 | 0.5371 | 0.6937 | 0.0066 | 0.9864 |
| `rouge_l_to_seed` | 458,595 | 0.7056 | 0.1186 | 0.4828 | 0.6374 | 0.7213 | 0.7912 | 0.8706 | 0.1226 | 1.0000 |
| `normalized_edit_distance` | 458,595 | 0.2983 | 0.1316 | 0.1197 | 0.2019 | 0.2788 | 0.3715 | 0.5597 | 0.0023 | 0.8351 |

**Appendix Table A10. Figure 6 split-level semantic means.**

| split | paraphrase metric rows | mean `bert_score_f1` | mean `semantic_similarity_to_seed` | mean `bleu_score_to_seed` | mean `rouge_l_to_seed` | mean `normalized_edit_distance` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| train | 367,150 | 0.8819 | 0.9251 | 0.4116 | 0.7055 | 0.2983 |
| validation | 45,925 | 0.8819 | 0.9251 | 0.4108 | 0.7052 | 0.2985 |
| test | 45,520 | 0.8823 | 0.9259 | 0.4128 | 0.7062 | 0.2979 |

**Appendix Table A11. Figure 6 paraphrase-diversity group statistics.**

| group metric | groups | mean | sd | p05 | p25 | median | p75 | p95 | min | max |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `bleu_mean` | 10,000 | 0.3065 | 0.1274 | 0.0938 | 0.2146 | 0.3076 | 0.3955 | 0.5157 | 0.0051 | 0.8441 |
| `bleu_min` | 10,000 | 0.1132 | 0.1174 | 0.0000 | 0.0000 | 0.1080 | 0.1911 | 0.3284 | 0.0000 | 0.7333 |
| `ttr_mean` | 10,000 | 0.8972 | 0.0285 | 0.8506 | 0.8807 | 0.8975 | 0.9151 | 0.9429 | 0.6013 | 0.9889 |
| `length_cv` | 10,000 | 0.0448 | 0.0227 | 0.0177 | 0.0303 | 0.0408 | 0.0543 | 0.0837 | 0.0056 | 0.3139 |

**Appendix Table A12. Figure 6 near-duplicate group diagnostic.**

| diagnostic | value |
| --- | ---: |
| paraphrase groups | 10,000 |
| near-duplicate groups, `bleu_min > 0.5` | 30 |
| near-duplicate group share | 0.30% |

The following tables provide the panel-level values behind Figure 7. They are
computed from `pqid_v1_license_valid_summary.json` and
`pqid_v1_public_open_summary.json`.

**Appendix Table A13. Figure 7 release-view composition by license category.**

| license category | internal rows | license-valid rows | public-open rows | restricted rows |
| --- | ---: | ---: | ---: | ---: |
| `permissive` | 311,724 | 311,724 | 311,724 | 0 |
| `copyleft` | 7,356 | 7,356 | 0 | 0 |
| `other` | 702 | 702 | 0 | 0 |
| `no_license` | 230,532 | 0 | 0 | 230,532 |

**Appendix Table A14. Figure 7 license-valid split composition.**

| split | license-valid rows | permissive | copyleft | reviewed other |
| --- | ---: | ---: | ---: | ---: |
| train | 255,852 | 249,420 | 5,898 | 534 |
| validation | 32,088 | 31,386 | 648 | 54 |
| test | 31,842 | 30,918 | 810 | 114 |

**Appendix Table A15. Figure 7 largest restricted-source repositories.**

| rank | repository | excluded rows |
| ---: | --- | ---: |
| 1 | `backordinary/QDP-FSL` | 53,754 |
| 2 | `wjy99-c/QDiff` | 49,044 |
| 3 | `lockephi/Allentown-L104-Node` | 29,874 |
| 4 | `dereklin1205/COMM_LAB_Final` | 4,212 |
| 5 | `peiyi1/nassc_code` | 1,704 |
| 6 | `Simula-COMPLEX/MutTG-paper` | 1,422 |
| 7 | `Xzore19/QEMI` | 1,392 |
| 8 | `AIComputing101/quantum-computing-101` | 1,356 |
| 9 | `PennyLaneAI/llvm-project` | 1,356 |
| 10 | `NiloGregginz33/QMGRExperiments` | 1,044 |

**Appendix Table A16. Figure 7 release totals.**

| release view | instruction rows |
| --- | ---: |
| internal construction object | 550,314 |
| license-valid public release | 319,782 |
| public-open permissive fallback | 311,724 |
| restricted/internal-only rows | 230,532 |

The following table provides the panel-level values behind Supplementary Figure
S5. It is computed from `instruction_language_audit_v1_summary.json` and the
cached `LANGUAGE_AUDIT_FLOW_SUMMARY.json` file used by
`plot_quantitative_figures.ipynb`. In panel B, the alluvial ribbons use
square-root count scaling for legibility, but the table reports the exact row
counts.

**Appendix Table A17. Supplementary Figure S5 language-audit panel values.**

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

The following table provides the behavioural-family values behind
Supplementary Figure S6. It is generated from
`REPO_LICENSE_DISTRIBUTION.csv` by `plot_license_behavior_panel.py` and is meant
to describe reuse behaviour at a higher level than exact SPDX-style identifiers.

**Appendix Table A18. Supplementary Figure S6 license-behaviour family values.**

| behaviour family | rows | share of all instruction rows | summed repository-license groups | interpretation |
| --- | ---: | ---: | ---: | --- |
| no detected public license | 230,532 | 41.8910% | 2,733 | restricted/internal-only material with no detected public license |
| permissive / low-obligation | 310,974 | 56.5085% | 1,628 | low-obligation reuse family dominated by MIT and Apache-2.0 |
| weak file/library reciprocity | 1,380 | 0.2508% | 22 | license-valid material with file-, library-, or implementation-scoped reciprocity signals |
| strong or network reciprocity | 7,356 | 1.3367% | 163 | license-valid but not public-open material with stronger reciprocal or network-use obligations |
| attribution/content | 72 | 0.0131% | 4 | reviewed content-style attribution license material |

The same script also writes
`LICENSE_BEHAVIOR_RELEASE_VIEW_DISTRIBUTION.csv`, which records how these
families appear in the construction corpus, license-valid view, public-open
view, and restricted view.

## References

1. Wilkinson, M. D. et al. The FAIR Guiding Principles for scientific data
   management and stewardship. *Scientific Data* **3**, 160018 (2016).
   https://doi.org/10.1038/sdata.2016.18
2. Gebru, T. et al. Datasheets for datasets. *Communications of the ACM*
   **64**, 86-92 (2021). https://doi.org/10.1145/3458723
3. Bender, E. M. & Friedman, B. Data statements for natural language
   processing: Toward mitigating system bias and enabling better science.
   *Transactions of the Association for Computational Linguistics* **6**,
   587-604 (2018). https://doi.org/10.1162/tacl_a_00041
4. Mitchell, M. et al. Model cards for model reporting. In *Proceedings of the
   Conference on Fairness, Accountability, and Transparency*, 220-229 (ACM,
   2019). https://doi.org/10.1145/3287560.3287596
5. Pushkarna, M., Zaldivar, A. & Kjartansson, O. Data cards: Purposeful and
   transparent dataset documentation for responsible AI. In *Proceedings of
   the 2022 ACM Conference on Fairness, Accountability, and Transparency*,
   1776-1826 (ACM, 2022). https://doi.org/10.1145/3531146.3533231
6. Kalliamvakou, E., Gousios, G., Blincoe, K., Singer, L., German, D. M. &
   Damian, D. The promises and perils of mining GitHub. In *Proceedings of the
   11th Working Conference on Mining Software Repositories*, 92-101 (ACM,
   2014). https://doi.org/10.1145/2597073.2597074
7. Husain, H., Wu, H.-H., Gazit, T., Allamanis, M. & Brockschmidt, M.
   CodeSearchNet challenge: Evaluating the state of semantic code search.
   arXiv:1909.09436 (2019).
8. Lu, S. et al. CodeXGLUE: A machine learning benchmark dataset for code
   understanding and generation. arXiv:2102.04664 (2021).
9. Chen, M. et al. Evaluating large language models trained on code.
   arXiv:2107.03374 (2021).
10. Hendrycks, D. et al. Measuring coding challenge competence with APPS.
   *Advances in Neural Information Processing Systems* **34** (2021).
   https://doi.org/10.48550/arXiv.2105.09938
11. Austin, J. et al. Program synthesis with large language models.
   arXiv:2108.07732 (2021).
12. Lai, Y. et al. DS-1000: A natural and reliable benchmark for data science
   code generation. In *Proceedings of the 40th International Conference on
   Machine Learning*, 18319-18345 (PMLR, 2023).
13. Li, Y. et al. Competition-level code generation with AlphaCode. *Science*
   **378**, 1092-1097 (2022). https://doi.org/10.1126/science.abq1158
14. Ren, S. et al. CodeBLEU: A method for automatic evaluation of code
   synthesis. arXiv:2009.10297 (2020).
15. Kocetkov, D. et al. The Stack: 3 TB of permissively licensed source code.
   arXiv:2211.15533 (2022).
16. Li, R. et al. StarCoder: may the source be with you! *Transactions on
   Machine Learning Research* (2023). https://doi.org/10.48550/arXiv.2305.06161
17. Lee, K. et al. Deduplicating training data makes language models better.
   In *Proceedings of the 60th Annual Meeting of the Association for
   Computational Linguistics*, 8424-8445 (ACL, 2022).
   https://doi.org/10.48550/arXiv.2107.06499
18. Vishwakarma, S. K. L. P. et al. Qiskit HumanEval: An evaluation benchmark
    for quantum code generative models. In *IEEE International Conference on
    Quantum Computing and Engineering (QCE)* (2024).
    https://doi.org/10.48550/arXiv.2406.14712
19. Mikuriya, T. et al. QCoder Benchmark: Bridging language generation and
    quantum hardware through simulator-based feedback. arXiv:2510.26101
    (2025).
20. Slim, A. et al. QuanBench+: A unified multi-framework benchmark for
    LLM-based quantum code generation. arXiv:2604.08570 (2026).
21. Aleksandrowicz, G. et al. Qiskit: An open-source framework for quantum
    computing. Zenodo (2019). https://doi.org/10.5281/zenodo.2562111
22. Zhang, T., Kishore, V., Wu, F., Weinberger, K. Q. & Artzi, Y. BERTScore:
    Evaluating text generation with BERT. In *International Conference on
    Learning Representations* (2020).
23. Reimers, N. & Gurevych, I. Sentence-BERT: Sentence embeddings using Siamese
    BERT-networks. In *Proceedings of EMNLP-IJCNLP*, 3982-3992 (ACL, 2019).
    https://doi.org/10.18653/v1/D19-1410
24. Papineni, K., Roukos, S., Ward, T. & Zhu, W.-J. BLEU: A method for
    automatic evaluation of machine translation. In *Proceedings of the 40th
    Annual Meeting of the Association for Computational Linguistics*, 311-318
    (ACL, 2002). https://doi.org/10.3115/1073083.1073135
25. Lin, C.-Y. ROUGE: A package for automatic evaluation of summaries. In *Text
    Summarization Branches Out*, 74-81 (ACL, 2004).
26. Pareto, V. *Cours d'economie politique*. Vol. 2. F. Rouge, Lausanne
    (1897).
27. Newman, M. E. J. Power laws, Pareto distributions and Zipf's law.
    *Contemporary Physics* **46**, 323-351 (2005).
    https://doi.org/10.1080/00107510500052444
28. Gini, C. *Variabilita e mutabilita: contributo allo studio delle
    distribuzioni e delle relazioni statistiche*. Tipografia di P. Cuppini,
    Bologna (1912).
29. Rhoades, S. A. The Herfindahl-Hirschman index. *Federal Reserve Bulletin*
    **79**, 188-189 (1993).
30. Clauset, A., Shalizi, C. R. & Newman, M. E. J. Power-law distributions in
    empirical data. *SIAM Review* **51**, 661-703 (2009).
    https://doi.org/10.1137/070710111

## Author Contributions

E.A.G. designed and implemented the PQID construction pipeline, performed the
data acquisition, processing, validation, instruction generation, remediation,
release filtering, and manuscript drafting. K.L. supervised the project and
provided academic oversight. Both authors reviewed and approved the manuscript.

## Competing Interests

TODO: insert final competing-interest statement.

## Funding

TODO: insert final funding statement.

## Ethics Statement

PQID does not contain human-subject experimental data or animal-subject data.
The primary ethical and governance considerations concern public-code
provenance, license status, attribution, and responsible redistribution.

## Proposed Figures and Tables

The current figure plan uses designed SVG/PNG schematics for the main workflow,
release, generation, and audit figures. Mermaid diagrams are retained as
auditable source diagrams and supplementary workflow documentation rather than
as the primary manuscript visual style.

| item | source | intended placement |
| --- | --- | --- |
| Figure 1. PQID construction pipeline | `submissions/scientific_data/figures/fig1_pqid_construction_pipeline_designed.svg/png/pdf` | Methods overview |
| Figure 2. Release stratification | `submissions/scientific_data/figures/fig2_release_stratification_designed.svg/png/pdf` | Data Records or release-view subsection |
| Figure 3. Quality-aware seed generation workflow | `submissions/scientific_data/figures/fig3_seed_generation_workflow_designed.svg/png/pdf` | Methods, seed-generation subsection |
| Figure 4. Validation and audit layers | `submissions/scientific_data/figures/fig4_validation_audit_layers_designed.svg/png/pdf` | Technical Validation |
| Figure 5. Benchmark-readiness statistics | `submissions/scientific_data/plot_quantitative_figures.ipynb` -> `figures/fig5_readiness_statistics.*` | Benchmark-readiness scoring / Technical Validation |
| Figure 6. Semantic and paraphrase quality | `submissions/scientific_data/plot_quantitative_figures.ipynb` -> `figures/fig6_semantic_paraphrase_quality.*` | Semantic, diversity, and language validation |
| Figure 7. License and release composition | `submissions/scientific_data/plot_quantitative_figures.ipynb` -> `figures/fig7_release_composition.*` | License-filtered release views |
| Supplementary Figure S1. Metadata schema architecture | `submissions/scientific_data/figures/suppfig_s1_metadata_schema_architecture.mmd` | Supplementary methods |
| Supplementary Figure S2. License-governance decision tree | `submissions/scientific_data/figures/suppfig_s2_license_governance_decision_tree.mmd` | Supplementary governance documentation |
| Supplementary Figure S3. Benchmark-readiness gate logic | `submissions/scientific_data/figures/suppfig_s3_benchmark_readiness_gate_logic.mmd` | Supplementary validation documentation |
| Supplementary Figure S4. Acquisition Pareto and diminishing returns | `submissions/scientific_data/plot_quantitative_figures.ipynb` -> `figures/suppfig_s4_acquisition_pareto_diminishing_returns.*` | Supplementary acquisition diagnostics |
| Supplementary Figure S5. Linguistic distribution and audit flow | `submissions/scientific_data/plot_quantitative_figures.ipynb` -> `figures/suppfig_s5_linguistic_distribution.*` | Supplementary language-audit diagnostics |
| Supplementary Figure S6. License-behaviour and obligation clustering | `submissions/scientific_data/plot_license_behavior_panel.py` -> `figures/suppfig_s6_license_behavior_panel.*` | Supplementary license-governance diagnostics |
| Data Records table | in manuscript | Data Records |
| Technical Validation table | in manuscript | Technical Validation |
| Schema field-cluster table | in manuscript | Data Records / Metadata Schema |
| License distribution table | generated artifacts and manuscript summaries | License-filtered release views |
| Appendix Table A1. Repository-level concentration diagnostics | `pqid_2026_raw_github_circuits.jsonl` | Appendix |
| Appendix Table A2. Pareto coverage thresholds | `pqid_2026_raw_github_circuits.jsonl` | Appendix |
| Appendix Table A3. Highest-yield source repositories | `pqid_2026_raw_github_circuits.jsonl` | Appendix |
| Appendix Table A4. Rank-band marginal yield | `pqid_2026_raw_github_circuits.jsonl` | Appendix |
| Appendix Tables A5-A8. Figure 5 readiness diagnostics | `pqid_2026_master_corpus.jsonl` | Appendix |
| Appendix Tables A9-A12. Figure 6 semantic and diversity diagnostics | clean split files; `paraphrase_diversity.jsonl` | Appendix |
| Appendix Tables A13-A16. Figure 7 release-composition diagnostics | release-view summary JSON files | Appendix |
| Appendix Table A17. Supplementary Figure S5 language-audit panel values | `instruction_language_audit_v1_summary.json`; `LANGUAGE_AUDIT_FLOW_SUMMARY.json` | Appendix |
| Appendix Table A18. Supplementary Figure S6 license-behaviour family values | `REPO_LICENSE_DISTRIBUTION.csv`; `LICENSE_BEHAVIOR_DISTRIBUTION.csv`; `LICENSE_BEHAVIOR_RELEASE_VIEW_DISTRIBUTION.csv` | Appendix |

Draft captions and rendering notes are maintained in
`submissions/scientific_data/figures/FIGURE_INDEX.md`.

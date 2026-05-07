# PQID Scientific Data Manuscript

[![Main PQID Repository](https://img.shields.io/badge/GitHub-main%20PQID%20repository-181717?logo=github)](https://github.com/Elias-Abebe-Gasparini/PQID-Dataset)
[![Hugging Face Dataset](https://img.shields.io/badge/Hugging%20Face-dataset-FFD21E?logo=huggingface&logoColor=000)](https://huggingface.co/datasets/Elias-Abebe-Gasparini/PQID)
[![Gradio Gateway](https://img.shields.io/badge/Gradio-dataset%20gateway-F97316?logo=gradio&logoColor=white)](https://huggingface.co/spaces/Elias-Abebe-Gasparini/PQID-Dataset-Gateway)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20024477.svg)](https://doi.org/10.5281/zenodo.20024477)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE.md)
[![Cite this repository](https://img.shields.io/badge/Cite-CITATION.cff-blue.svg)](CITATION.cff)
[![Fund this work](https://img.shields.io/badge/Fund-this%20research-EA4AAA?logo=githubsponsors&logoColor=white)](https://github.com/sponsors/Elias-Abebe-Gasparini)

This child repository contains the manuscript package for the Scientific Data
Data Descriptor associated with the Parallel Quantum Instruction Dataset
(PQID).

Working title:

**PQID: A License-Aware, Quality-Audited Instruction Dataset for Quantum Programming**

## Repository Role

This repository is a manuscript and figure companion to the main PQID dataset
repository. It is meant to make the article draft, figure assets, figure
generation scripts, and submission-facing audit materials easier to inspect
without exposing unrelated project planning files or internal dataset rows.

## Publication Stack

- Main dataset repository: <https://github.com/Elias-Abebe-Gasparini/PQID-Dataset>
- Hugging Face dataset: <https://huggingface.co/datasets/Elias-Abebe-Gasparini/PQID>
- Zenodo DOI: <https://doi.org/10.5281/zenodo.20024477>
- Interactive dataset gateway: <https://huggingface.co/spaces/Elias-Abebe-Gasparini/PQID-Dataset-Gateway>
- Gateway source repository: <https://github.com/Elias-Abebe-Gasparini/PQID-Dataset-Gateway>

## Contents

- `manuscript/` contains the Markdown manuscript draft and the current
  Scientific Data template DOCX export.
- `figures/` contains manuscript and supplementary figures in PNG/SVG/PDF
  formats, together with figure source files where available.
- `analysis/` contains the figure-generation and license-distribution scripts
  used for manuscript visuals and tables.
- `docs/` contains compact public-facing documentation fragments and appendix
  tables.
- `submission/` contains the submission checklist used to track manuscript
  closeout status.

## Data Availability

This repository does not redistribute the PQID dataset rows directly. The
public-open dataset files are distributed through Hugging Face and archived via
Zenodo. The manuscript describes both the license-valid internal audit view and
the permissive-only public-open release view.

## License Status

This manuscript companion repository is released under the Creative Commons
Attribution 4.0 International license (CC BY 4.0). Reuse is allowed with proper
attribution. For academic reuse, cite this repository, the associated dataset,
and the final article when available. See `LICENSE.md` and `CITATION.cff`.

The helper scripts are included to support manuscript auditability. If a
software-specific license is needed for script reuse in another project, contact
the authors.

## Funding

This work was developed as part of the PQID publication stack. Support for
continued maintenance, dataset documentation, and interactive research
infrastructure can be directed through GitHub Sponsors:
<https://github.com/sponsors/Elias-Abebe-Gasparini>.

## Safety Notes

This child repository was curated from `PQID/submissions/scientific_data`.
Private planning files, funding notes, unrelated paper drafts, raw JSONL dataset
rows, Word temporary files, and local absolute-path traces are intentionally
excluded.

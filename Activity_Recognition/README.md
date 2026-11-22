# EOG Activity Classification

## Overview

This project explores the use of Electrooculography (EOG) signals for human activity recognition using machine learning. It implements a baseline Random Forest classifier in MATLAB to identify activity patterns from eye movements.

The project is developed as part of **Project IRIS**, which investigates EOG-based human-computer interaction and the potential use of eye movements as an alternative communication interface.

## Dataset

This project uses the *Eye Movement Analysis for Activity Recognition Using EOG* dataset, available through the University of Stuttgart.

**Dataset:** https://doi.org/10.18419/darus-3135

Dataset characteristics:
- Approximately 8 hours of EOG recordings
- 8 participants
- 2 experimental sessions per participant
- Horizontal and vertical EOG channels
- Sampling frequency: 128 Hz
- Five office activities and a NULL/rest class

The activities include copying text, reading printed material, taking handwritten notes, watching videos, and browsing the Web.

**Note:** The current dataset file contains eight numeric annotation labels, while the published description specifies six activity classes. The exact label mapping requires further verification.

## Methodology

The classification pipeline consists of the following stages:

### 1. Data Loading

EOG recordings are loaded from MATLAB `.mat` files. The current implementation uses `participant1_0.mat`.

### 2. Signal Visualization

The two EOG channels and corresponding activity labels are plotted to visualize eye-movement patterns and activity transitions.

### 3. Window Segmentation

The EOG signals are divided into non-overlapping 1-second windows (128 samples per window). Windows are generated within continuous labeled segments to avoid mixing different activity labels.

### 4. Feature Extraction

Eight statistical features are extracted from each EOG channel:

- Mean
- Standard deviation
- Minimum
- Maximum
- Signal range
- Root mean square (RMS)
- Mean absolute difference
- Net signal change

This produces a total of **16 features per window**.

### 5. Random Forest Classification

A Random Forest classifier consisting of 100 decision trees is trained using MATLAB's `TreeBagger` function.

The dataset windows are divided into:
- 80% training data
- 20% testing data

Each decision tree learns relationships between EOG features and activity labels. Predictions from the ensemble are combined to determine the final classification.

### 6. Model Evaluation

The model is evaluated using:
- Classification accuracy
- Confusion matrix
- Class distribution analysis

The current random window-level split is intended for exploratory testing. Future evaluation will use session-level or participant-level separation to better assess generalization.

## Requirements

- MATLAB
- Statistics and Machine Learning Toolbox
- Signal Processing Toolbox (if optional filtering is enabled)

## How to Run

1. Download the EOG dataset from the link above.
2. Open the MATLAB classification script.
3. Update the dataset folder path to match your local directory.
4. Run the script.
5. Review the generated signal plots, feature statistics, classification accuracy, and confusion matrix.

## Future Improvements

- Investigate EOG preprocessing and artifact removal
- Verify the dataset's numeric activity-label mapping
- Evaluate additional participants and recording sessions
- Improve feature extraction for eye-movement patterns
- Compare Random Forest with other classification algorithms
- Explore real-time eye-movement recognition
- Investigate translating intentional eye movements into computer commands for assistive communication

## Project Status

**In Development — Baseline Classification**

The current implementation establishes an initial machine learning pipeline for EOG activity classification. Further work will focus on preprocessing, model validation, and developing eye-movement-based interaction capabilities.

## Acknowledgments

This project uses the *Eye Movement Analysis for Activity Recognition Using EOG* dataset hosted by the University of Stuttgart.

Dataset DOI: https://doi.org/10.18419/darus-3135


# Virus Expert System

This repository contains a Prolog-based expert system that diagnoses potential virus infections by analysing patient symptoms, bio-data, and exposure history. The system is designed to replicate logical decision-making in medical diagnostics.

## Features
- **Input Data**:
  - **Bio-data**: Age and gender to assess risk factors (e.g., age > 70, male gender).
  - **Symptoms**: Classified as common, less common, and serious.
  - **Exposure**: Evaluates interactions with infected individuals or contaminated surfaces.

- **Logic Rules**:
  - **Recent Exposure**: Differentiates between direct and indirect exposure within the incubation period (1–14 days).
  - **Infection Severity**:
    - **Mild**: Fever and tiredness without serious symptoms or high-risk factors.
    - **Moderate**: Mild symptoms with aches or high-risk factors.
    - **Severe**: Serious symptoms or a combination of serious symptoms and high-risk factors.
    - **Asymptomatic**: Recent exposure with no symptoms.
    - **No Infection**: None of the above conditions met.

- **Recommendations**:
  Generates tailored advice based on the severity of the infection.

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/ArturoVegal/virus-expert-system.git
   cd virus-expert-system

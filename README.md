# Speech Recognition using MATLAB

This project implements a **template-based speech recognition system** using **cross-correlation** to identify spoken keywords.  
It provides a clean, modular, and well-structured MATLAB implementation suitable for academic, research, and professional use.

---

## Features

- Full MATLAB implementation (no toolboxes required except basic signal processing)
- Template-based recognition using **normalized cross-correlation**
- Automatic preprocessing:
  - Resampling  
  - Pre-emphasis  
  - Band-pass filtering  
  - Silence trimming  
  - Duration normalization  
- Multi-class recognition based on reference templates  
- Evaluation pipeline with accuracy and confusion matrix  
- Optional **real-time microphone recognition demo**  
- Clean modular structure similar to professional research repos

---

## Project Structure

```
speech_recognition_matlab/
│
├─ main.m
├─ config_speech_recognition.m
├─ load_dataset.m
├─ preprocess_audio.m
├─ compute_normalized_xcorr.m
├─ predict_label.m
├─ evaluate_model.m
├─ plot_signal.m
└─ recognize_live.m
```

---

## Dataset Structure

Create a folder named `data/` and organize it as follows:

```
speech_recognition_matlab/
└─ data/
   ├─ reference/
   │   ├─ yes/
   │   │   ├─ yes_01.wav
   │   │   └─ yes_02.wav
   │   └─ no/
   │       ├─ no_01.wav
   │       └─ no_02.wav
   └─ test/
       ├─ yes/
       │   ├─ yes_t01.wav
       │   └─ yes_t02.wav
       └─ no/
           ├─ no_t01.wav
           └─ no_t02.wav
```

Each subfolder corresponds to a **class label**.

---

## How It Works

### 1. Preprocessing
Each audio file undergoes:
- Resampling to 16 kHz  
- Pre-emphasis  
- Band-pass filtering (300–3400 Hz)  
- Silence trimming based on energy threshold  
- Length normalization  

### 2. Recognition
For a test signal:
- Compute normalized cross-correlation with every reference template
- Assign the label with the **highest similarity score**

### 3. Evaluation
The project computes:
- Per-sample predictions
- Overall accuracy
- Confusion matrix (if available)

---

## Run the Project

In MATLAB:

```matlab
main
```

This will automatically:
- Load the data
- Preprocess signals
- Evaluate accuracy
- Optionally start the live demo

---

## Live Speech Recognition Demo

Enable in configuration:

```matlab
cfg.enableLiveDemo = true;
```

MATLAB will:
- Record from microphone  
- Preprocess audio  
- Predict the closest keyword  
- Display scores per class  

---

## Requirements

- MATLAB R2018+ recommended  
- Microphone (optional for live demo)  
- WAV dataset  

---

## Author

**Mobin Yousefi**  
GitHub: https://github.com/mobinyousefi-cs  
Master's Degree in Computer Science

---

## License

This project is released under the **MIT License**.


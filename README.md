#  CNN Image Classification in MATLAB

This project trains a **Convolutional Neural Network (CNN)** in MATLAB to classify multi-channel image data. It uses preprocessed features and labels stored in `.mat` files, applies manual dataset splitting and calibration, and evaluates the network using multiple confusion matrices.

---

##  Project Structure

### Files:
- `feature.mat` — 4D array containing input image data (`height x width x channels x samples`)
- `label.mat` — Ground truth labels corresponding to the samples
- `cnn_classification.m` — Main script for:
  - Data loading and shuffling
  - Dataset splitting (train/val/test)
  - CNN design
  - Training and evaluation

---

##  Requirements

- MATLAB (tested with R2021b or later)
- Deep Learning Toolbox
- Image Processing Toolbox (for `imageInputLayer`)
- `.mat` files (`feature.mat`, `label.mat`) in the same directory

---

##  How It Works

### 1. **Load & Shuffle Data**
The dataset is loaded from `.mat` files and shuffled using `randperm()` to avoid training bias.

### 2. **Train/Validation/Test Split**
- 70% Training
- 10% Validation
- 20% Testing

### 3. **CNN Architecture**
The model includes:
- Two convolutional layers with ReLU and max pooling
- A fully connected layer
- Softmax and classification layers

### 4. **Training Configuration**
- Optimizer: RMSProp
- Epochs: 100
- Learning Rate: 0.01
- Validation every 5 iterations with early stopping (patience = 4)
- Real-time training progress plot enabled

### 5. **Evaluation**
Predictions are made on:
- All data
- Training set
- Validation set
- Test set

Each is visualized with a **confusion matrix** for performance analysis.

---

##  Output

- **Confusion matrices** show classification accuracy across the full dataset, as well as each data split.
- Predictions are made using `predict()` and post-processed with `max()` and `categorical()` to match label format.

---


## 📝 Notes

- Input image size is `[28 x 28 x 2]`, meaning **2-channel images** (e.g., dual-modality or filtered input).

---


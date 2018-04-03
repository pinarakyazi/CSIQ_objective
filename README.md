# CSIQ_objective

This software provides computations of the following objective metrics on the CSIQ database [1]:
MSE, SNR, PSNR, PSNR-HVS, PSNR-HVS-M, UQI, SSIM, MS-SSIM, M-SVD, QILV, IFC, VIF, VIFp,
FSIM, IW-MSE, IW-PSNR, IW-SSIM, WSNR, VSNR. Codes are obtained from implementations
within the references in the end of this document.

The software also plots the results (1-DMOS) against subjective scores for comparison, and computes the
Pearson Correlation Coefficient between objective results and subjective ratings in CSIQ database.

Plots are saved in the same folder as .png files.

PSNR-HVS, PSNR-HVS-M and VIFp results are computed using the VQMT software [2].
The OpenCV library (http://opencv.willowgarage.com/wiki/) needs to be installed to run VQMT.
Only the core and imgproc modules are required.

# PREREQUISITE

MATLAB (versions since 2013)

# USAGE

Download all folders and files in https://drive.google.com/drive/folders/13KRftoy8b38uUBx9J338gG5R_Deymix0?usp=sharing
to local folder.

Call computeObjective.m in MATLAB.


# REFERENCES

[1]   CSIQ Image Quality Database, vision.eng.shizuoka.ac.jp/mod/page/view.php?id=23.
[2]   https://mmspg.epfl.ch/vqmt
[3]   Zhou, Wang and Alan C. Bovik. “A Universal Image Quality Index.” IEEE Signal Processing Letters 9.3 (2002): 81-84.
[4]   Aja-Fernandez, Santiago, et al. "Image quality assessment based on local variance." Engineering in Medicine and Biology Society, 2006. EMBS'06. 28th Annual International Conference of the IEEE. IEEE, 2006.
[5]   Sheikh, Hamid R., Alan C. Bovik, and Gustavo De Veciana. "An information fidelity criterion for image quality assessment using natural scene statistics." IEEE Transactions on image processing 14.12 (2005): 2117-2128.
[6]   H.R. Sheikh.and A.C. Bovik, "Image information and visual quality," IEEE Transactions on Image Processing , vol.15, no.2,pp. 430- 444, Feb. 2006.
[7]   Zhang, Lin, et al. "FSIM: A feature similarity index for image quality assessment." IEEE transactions on Image Processing20.8 (2011): 2378-2386.
[8]   Wang, Zhou, and Qiang Li. "Information content weighting for perceptual image quality assessment." IEEE Transactions on Image Processing 20.5 (2011): 1185-1198.
[9]   Mannos, James, and David Sakrison. "The effects of a visual fidelity criterion of the encoding of images." IEEE transactions on Information Theory 20.4 (1974): 525-536.
[10] Mitsa, Theophano, and Krishna Lata Varkur. "Evaluation of contrast sensitivity functions for the formulation of quality measures incorporated in halftoning algorithms." Acoustics, Speech, and Signal Processing, 1993. ICASSP-93., 1993 IEEE International Conference on. Vol. 5. IEEE, 1993.
[11] MeTRriX MuX Visual Quality Assessment Package V1.1. https://github.com/sattarab/image-quality-tools. Originally developed at http://foulard.ece.cornell.edu/gaubatz/metrix_mux/

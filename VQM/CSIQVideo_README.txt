**********************
Please cite the following paper for the use of CSIQ video database: 
- P. V. Vu and D. M. Chandler, “ViS3: An Algorithm for Video Quality Assessment via Analysis of Spatial 
and Spatiotemporal Slices,” Journal of Electronic Imaging (JEI), 23(1), 01316, Feb 2014, doi: 10.1117/1.JEI.23.1.013016.

****************************************

Description

1. General info

	The CSIQ video database consists of 12 reference videos and 216 distorted videos with six different 
types of distortion. All the videos are in the YUV420 format at a resolution of 832x480 and duration
of 10 seconds.

2. Video frame rates:

	The videos in the database have different frame rates, ranging from 24 fps to 60 fps. 
The detailed frame rate of each video is as below

24 fps
	Chipmunks_832x480_24
	Kimono_832x480_24
	ParkScene_832x480_24

25 fps
	Carving2_832x480_25

30 fps
	Flowervase_832x480_30
	Keiba_832x480_30
	Timelapse_832x480_30

50 fps
	BasketballDrive_832x480_50
	Cactus_832x480_50
	PartyScene_832x480_50

60 fps
	BQMall_832x480_60
	BQTerrace_832x480_60

3. Distortion types

	There are six types of distortion in the CSIQ video database; each type has three different
levels of distortion. The video indices corresponding to each distortion type is as follows

- H.264/AVC compression: _dst_01, _dst_02, _dst_03

- H.264 video with packet loss rate (plr): _dst_04, _dst_05, _dst_06

- MJPEG compression: _dst_07, _dst_08, _dst_09

- Wavelet compression (snow codec): _dst_10, _dst_11, _dst_12

- White noise: _dst_13, _dst_14, _dst_15

- HEVC compression: _dst_16, _dst_17, _dst_18


4. Experimental Protocol


     To collect subjective ratings of video quality, we conducted a psychovisual experiment following the SAMVIQ methodology in the darkened room using the HP Monitor, which is calibrated carefully. 35 subjects from Oklahoma State University with the age ranges from 21 to 32 were recruited to participate in this experiment. Subjects include both males and females with normal or correct-to-normal visual acuity. None of the subjects had previously looked at the videos in the database. 

     Subjects were instructed to seat comfortably at the viewing distance of 28 inches from the monitor. At the beginning, each subject was trained with two short videos to get familiar with the experiment. The subjects are divided into two groups so each video content is rated by either seventeen or eighteen subjects. 

     Each tested video is preloaded and carefully synchronized with the computer’s performance to make sure that the length of video display is exactly 10 seconds. The videos were displayed at their native resolution and the remaining areas of the display were set to gray. A continuous scale for video quality was displayed on the screen, with a cursor set at the center of the quality scale to avoid biasing the subject’s quality ratings. The subject is able to move the cursor to change the score after viewing the whole video sequence at least once; they were allowed to take as much time as needed to review the video and enter the score. They can even go back to change the score if they feel the previous entered one need to be modified. Once the score was entered, subject might proceed to the next video by clicking the Next button. In the new video content, subject cannot change the score of the previous content. During the experiment, subjects can take rest at any time but a break of at least 5 minutes is mandatory after a session of 30 minutes. 

    The experiment results are collected from all subjects for each tested video. A rejection criteron is applied to reject outliers, then the results are processed and reported in the form of Different Mean Opinion Score (DMOS) for the tested video. These results are used to evaluate and validate the performance of objective quality assessment algorithms. 
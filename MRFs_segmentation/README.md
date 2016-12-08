Author
------
Gweltaz Lever, ISAE Supaero
All rights reserved.

Description
-----------
The project aims at performing segmentation of images using an MRF process, a simulated annealing.  Depending on the script, the algorithms use Metropolis dynamics or Gibbs sampling.
The last application estimates image texture and performs the segmentation of urban area and countryside.

Usage
-----
The scripts can be launched within matlab. Just make sure the image used in the scripts is located in the right folder.

Algorithms
----------
The following approaches have been chosen:
- Step 1: 
	a. segmentation.m
The classes to be segmented have a pre-defined mean and variance. The Metropolis dynamic is combined with a simulated annealing algorithm in order to reach the right segmentation. A Potts model in a 4-connexity neighborhood is used.
	
	b. segmentation_8.m
Same algorithm but with a 8-connexity neighborhood.
	
	c. segmentation_Gibbs.m
The dynamic for the choice of the new pixel class changes from Metropolis to a Gibbs sampling method. 
	
- Step 2: segmentation_supervisee.m
Now, the segmentation is supervised. The operator choses squares in the image so that mean and variance properties of the classes can be directly calculated from the image.
	
	
- Step 3: 
	a. debruitage_1.m
Uses the previous algorithm to perform denoising in an image. It assigns the mean of the class considered to the pixels.

	b. debruitage_2.m
Improvement of the previous version using a markovian gaussian model.

- Step 4:
The goal is to extract the urban area from the countryside. The texture of the countryside and urban area are estimated with two different estimators (cf. UrbanDetec.m script).
The resulting images are used as inputs for the previous algorithms and a segmentation is obtained.

For french speakers, more information is available in the PDF. 

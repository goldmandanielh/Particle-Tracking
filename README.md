# Particle-Tracking
MATLAB code for particle tracking, linking, co-localization and inspection.
1) Separate each movie into green and red tif stacks.
2) For each movie, give the green and red stacks a common name, with green stack filename ending in "_green.tif" and red ending in "_red.tif".
3) To perform tracking, run scriptAIRLOCALIZEAndUTrackParallel.m, specifying the file location and green tif stacks of movies to be analyzed and setting the desired parameters. Tracking data is stored in the saved matlab structure.
4) Run scriptLinkTrack_n.m with the desired parameters to perform co-localization analysis and inspection. Each co-localized track will be desplayed (one at a time) and indicated on a still frame of the stack. Press "y" to accept, "n" to reject. Co-localization data is stored in the saved matlab structure.

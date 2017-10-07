# course3week4
Getting and cleaning data project

The code stores then sets the working directory to a relevant folder, then download/unzips the file in question.
Load the relevant packages next.

I pull out the labels from the 'features.txt' file for manipulation and assignment next, followed by reading in the x/y and subject test/train files.

I then add the exercise type (from the y_test/y_train files) into the X_test/X_train frames, followed by the relevant subject labels. After this i put the two major frames together into a master datafile that's reasonably tidy. I then pull out the variable names (again) in order to test for the specific regex keywords. Once i have that, i subset the data in order to end up with a final dataset that only has the variables i'm interested in.

I then cleaned the data, making the variable names more intelligable, and recoding the exercise types into something meaningful.

From there I aggregate the final table, and write it to text. 

I finish with resetting my working directory, for no reason other than personal satisfaction.

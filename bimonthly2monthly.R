# You can coppy this function to your notebook:

bimonthly2monthly = function(myData, ser){
  # This function take a column named ser in the data frame myData and change it from bi monthly to monthly by interpolating the data
  # NOTE: This function assumes that myData is sorted by time, either in descending or ascending order
  #  before using this function, it will be safe to run the command:  myData <- myData[order(myData$year,myData$period),]
  
  n = length(myData[[ser]]) # number of rows
  
  #first ignore the cases where either the first or the last observations are missing
  # we start by looping over the indeces from 2 
  # upto (but not including) the last observation 
  
  for(i in 2:(n-1)){
    if(is.na(myData[[ser]][i])){ #the value in place i is NaN
      myData[[ser]][i] = sqrt(myData[[ser]][i-1]*myData[[ser]][i+1]) #replace NaN with a geometric avg of i-1 and i+1
    } 
  }
  # after the above stage all the middle observations are full. Now we can treat the first and last one
  
  if(is.na(myData[[ser]][1])){ #the value in the first place is NaN
    myData[[ser]][1]= myData[[ser]][2]*(myData[[ser]][2]/myData[[ser]][3]) #assume the same growth rate from 2 to 1 to be from 1 to 0
  }
  
  if(is.na(myData[[ser]][n])){ #the value in the last place is NaN
    myData[[ser]][n]= myData[[ser]][n-1]*(myData[[ser]][n-1]/myData[[ser]][n-2]) #assume the same growth rate from n-2 to n-1 to be from n-1 to n
  }
  
  return(myData)
  
  # Usage (after you created your dataframe using multiSeriesV4() ):
  
  # First, sort the dataframe using:  
  #              df <- df[order(df$year,df$period),]
  # (replace df with the name you used for your data frame)
  
  # Second, use this function:
  #              df = bimonthly2monthly(df,'CUURS12BSAR')
  # (replace df with the name you used for your data frame and replace 'CUURS12BSAR' with a series name you used)
  # The function works on one series on a time (but you could put it in a loop.
  
}
# You can coppy this function to your notebook:

def bimonthly2monthly(myData, ser):
    # This function take a column named ser in the data frame myData and change it from bi monthly to monthly by interpolating the data
    # NOTE: This function assumes that myData is sorted from the latest month (position zero) to the oldest month
    #  before using this function, it will be safe to run the command:  myData.sort_values(by=['year','period'],inplace=True,ascending=False)
    
    n = len (myData[ser]) # number of rows

    #first ignore the cases where either the first or the last observations are missing
    # we start by looping over the indeces from 1 (which is the second place in Python)
    # upto (but not including) the last observation ()

    for i in range(1,n-1):

        if pd.isna(myData[ser].iat[i]): #the value in place i is NaN
            myData[ser].iat[i] = math.sqrt(myData[ser].iat[i-1]*myData[ser].iat[i+1]) #replace NaN with a geometric avg of i-1 and i+1

    # after the above stage all the middle observations are full. Now we can treat the first and last one

    if pd.isna(myData[ser].iat[0]): #the value in the first place is NaN
        myData[ser].iat[0] = myData[ser].iat[1]*(myData[ser].iat[1]/myData[ser].iat[2]) #assume the same growth rate from 2 to 1 to be from 1 to 0

    if pd.isna(myData[ser].iat[n-1]): #the value in the last place is NaN
        myData[ser].iat[n-1] = myData[ser].iat[n-2]*(myData[ser].iat[n-2]/myData[ser].iat[n-3]) #assume the same growth rate from n-2 to n-3 to be n-2 to n-1
        
    return myData
  
  # Usage (after you created your dataframe using multiSeriesV4() ):

  # First, sort the dataframe using:  
  #              df.sort_values(by=['year','period'],inplace=True,ascending=False)
  # (replace df with the name you used for your data frame)

  # Second, use this function:
  #              df = bimonthly2monthly(df,'CUURS12BSAR')
  # (replace df with the name you used for your data frame and replace 'CUURS12BSAR' with a series name you used)
  # The function works on one series on a time (but you could put it in a loop.

#!/usr/bin/env python
# coding: utf-8

# # NYU Programming for DataScience - Exercise 02

# #Getting the libraries

# In[2]:


get_ipython().run_line_magic('config', 'IPCompleter.greedy=True')


# In[3]:


import pandas as pd
import numpy as np


# # 1 - Imports the data into a data structure of your choice

# In[4]:


data = pd.read_csv('houseelf_earlength_dna_data.csv')


# In[5]:


data


# #Creating the DataFrame

# # 2 - Loops over the rows in the dataset

# In[ ]:


# 3 - For each row in the dataset checks to see if the ear length is large (>10 cm) or small (<=10 cm) and 
#determines the GC-content of the DNA sequence (i.e., the percentage of bases that are either G or C)


# In[33]:


df = pd.DataFrame(data)


# In[37]:


df['Size'] = np.where(df['earlength']>10, True, False)


# In[44]:


g = df['dnaseq'].str.count("G")
c = df['dnaseq'].str.count("C")
total = df['dnaseq'].str.len()
gc_total = g + c
gc_content = gc_total/total
gc_content
df['GC_Content'] = gc_content


# #Creating the new DataFrame with columns: ID, Size, GC content and Averages

# In[ ]:


# 4 - Stores this information in a table where the first column has the ID for the individual, 
#the second column contains the string ‘large’ or the string ‘small’ depending on the size of the individuals ears, 
#and the third column contains the GC content of the DNA sequence.


# In[47]:


new_df = pd.DataFrame(columns = ['ID','Size', 'GC_Content']) 
new_df['ID'] = df['id']
new_df['Size'] = df['Size'].map(
                   {True:'Large' ,False:"Small"})
new_df['GC_Content'] = df['GC_Content']*100
new_df


# # 5 - Prints the average GC-content for both large-eared elves and small-eared elves to the screen.

# In[63]:


large_df = new_df.loc[new_df['Size'] == 'Large']
average_l = large_df['GC_Content'].mean()
average_l


# In[64]:


small_df = new_df.loc[new_df['Size'] == 'Small']
average_s = small_df['GC_Content'].mean()
average_s


# In[67]:


new_df['AverageGC_Large'] = pd.Series(average_l, index=new_df.index[[0]])
new_df['AverageGC_Large'] = new_df['AverageGC_Large'].fillna('')
new_df['AverageGC_Small'] = pd.Series(average_s, index=new_df.index[[0]])
new_df['AverageGC_Small'] = new_df['AverageGC_Small'].fillna('')
new_df


# #Exporting to csv

# # 6 - Exports the table of individual level GC values to a CSV (comma delimited text) file titled grangers_analysis.csv.

# In[68]:


new_df.to_csv("grangers_analysis.csv")


# # End

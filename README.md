# AI Fin Fraud Detector
![teaser](teaser.png)
> Please refer to the README.md in the "Code" folder to see the detail experiment results and interpretations.

The goal of this project is to create an AI fraud detector app to prevent middle-aged and elderly people from suffering telephone fraud, reducing criminal behavior and financial losses instantly.

1. **Artificial intelligence usage**: 
   - **Data Collection**:  In order to ensure the accuracy of judgment, we use the content of real fraud calls as the criteria for keyword selection, and crawl real fraud phone information from foreign forums through SeleniumModule and BeautifulSoup, such as the fraud discussing community "SEamPhoneCalls", Ruura Forum , Yuutube channel Kittoga, etc.
   - **Natural Language Processing**:  NLTK Module conducts text analysis on all data obtained by crawlers, using part-of-speech tagging to extract the noun keywords of the text and creates word bags, and applies Counter function to perform word frequency analysis and count the top 50 most frequently occurring keywords. The results are presented through bar chart and word cloud.

2. **Application front end**:

3. **Application back end**:  

By achieving these goals, our team looks forward to not only helping people prevent telephone fraud but also assisting police agencies to beat scammers. 

## Contributors
| 組員    | 系級              | 學號       | 職位                     | 工作分配             |
|---------|-------------------|------------|--------------------------|----------------------|
| 賴冠儒  | 廣電四/人智應四   | 110405026  | Project Manager & AI Engineer     | Progress arangement, AI programming |
| 蔡安德  | 統計三            | 110405193  |  AI Engineer               | AI programming |
| 李肇恆  | 經濟三            | 110208063  | AI Engineer               | AI programming, Theses researching |
| 許兆豐  | 廣電四/數位四     | 110405027  | APP Designer & Front-end engineer       | APP designing, Front-end programming |
| 簡子策  | 已畢業            | NA  |  APP Front-end engineer               | Front-end programming |
| 邵以懷  | 新聞三            | 111405131  | APP Back-end engineer               | Back-end programming, Theses researching, External liaison |
| 李淳皓  | 資管三/數位三     | 111306020  | APP Back-end engineer               | Back-end programming |

## Folder organization and its related description
idea by Noble WS (2009) [A Quick Guide to Organizing Computational Biology Projects.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424) PLoS Comput Biol 5(7): e1000424.

### docs
* Your presentation, 1122_DS-FP_groupID.ppt/pptx/pdf (i.e.,1122_DS-FP_group1.ppt), by **06.13**
* Any related document for the project, i.e.,
  * discussion log
  * software user guide

### data
* Input
  * Source
  * Format
  * Size

### code
* Analysis steps
* Which method or package do you use?
* How do you perform training and evaluation?
  * Cross-validation, or extra separated data
* What is a null model for comparison?

### results
* What is your performance?
* Is the improvement significant?

## References
* Packages you use
* Related publications

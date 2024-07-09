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

## Project structure(show at most 3 hiararchy)
finalproject-group1
├─ Code
│  ├─ AI part
│  │  ├─ NLP_Words_Frequency_Counting.ipynb
│  │  ├─ Web Scraping.ipynb
│  │  └─ heart.png
│  ├─ Backend
│  │  ├─ api
│  │  ├─ node_modules
│  │  ├─ app.js
│  │  ├─ package-lock.json
│  │  └─ package.json
├─ Data
│  ├─ scam_records_1.csv
│  ├─ scam_records_2.csv
│  ├─ scam_records_3.csv
│  ├─ scam_records_4.csv
│  └─ scam_records_5.csv
├─ Doc
│  ├─ Project poster.pdf
│  └─ Project proposal.pdf
├─ README.md
└─ teaser.png

## Theses References
* Z. L. Liu*, "Legal system-oriented telecom fraud detection, identification and prevention," 2023. Thesis. School of Law, Hebei Finance University.
* Jian-jia Su and Yun-nung Chen, "Modeling Real-Time Call Behaviors for Fraudulent Phone Call Detection," 2019. Thesis. National Taiwan University.
* Johan H van Heerden, "Detecting Fraud in Cellular Telephone Networks," 2005. Thesis. Operational Analysis University of Stellenbosch.

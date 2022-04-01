from collections import namedtuple
import altair as alt
import math
import pandas as pd
import streamlit as st
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

"""
# Cross Sectional Child Income Statistics by College Tier and Parent Income Percentile
### Authors: Vincent Wilmet, Marinie Tao, Alia Haiji

Drawing on the data collected by [Opportunity Insights](https://opportunityinsights.org/data/), a research lab at Harvard 
led by the famous economist [Raj Chetty](https://scholar.google.com/citations?hl=en&user=PhDDPiUAAAAJ&view_op=list_works&sortby=pubdate),
we aim to visualize the _full_ landscape of education (in)equalities. 

The data is derived by a mix of Obama's [College Scorecard (2015)](https://collegescorecard.ed.gov/) and de-identified 
public data from 1996-2014 American [income tax returns (W-2 Forms)](https://www.irs.gov/forms-pubs/about-form-w-2). 
The *70+ million* children<->parent pairs were drawn between 1978-1991 if they are claimed as dependents by the parent tax 
filers in the U.S, cross referenced and validated with proof of enrollment via the [1098-T forms](https://www.irs.gov/forms-pubs/about-form-1098-t)
submitted to the United States Internal Revenue Service (IRS) by a student/their university.

## Figure 1: 
"""

image = Image.open("img/Post-grad-parent-earning-by-tier.png")
st.image(image, caption="Post-grad-parent-earning-by-tier") #Image name

"""
## Figure X: 
"""
option = st.selectbox(
     'View figure by ',
     ('Values', 'Percentile'))

st.write('You selected:', option)

if option == 'Values': image = Image.open("img/Post-grad-earning-by-tier.png")
elif option == 'Percentile': image = Image.open("img/Post-Grad Earnings Percinetile by Tier.png")
fig = plt.figure()
plt.imshow(image)
plt.axis("off")
st.pyplot(fig)


# with st.echo(code_location='below'):
    # total_points = st.slider("Number of points in spiral", 1, 5000, 2000)
    # num_turns = st.slider("Number of turns in spiral", 1, 100, 9)

    # Point = namedtuple('Point', 'x y')
    # data = []

    # points_per_turn = total_points / num_turns

    # for curr_point_num in range(total_points):
    #     curr_turn, i = divmod(curr_point_num, points_per_turn)
    #     angle = (curr_turn + 1) * 2 * math.pi * i / points_per_turn
    #     radius = curr_point_num / total_points
    #     x = radius * math.cos(angle)
    #     y = radius * math.sin(angle)
    #     data.append(Point(x, y))

    # st.altair_chart(alt.Chart(pd.DataFrame(data), height=500, width=500)
    #     .mark_circle(color='#0068c9', opacity=0.5)
    #     .encode(x='x:Q', y='y:Q'))




"""
## Links:

* Code: [github](https://github.com/vincentwi/streamlit-example)
* Resources: [Opportunity Insights](https://opportunityinsights.org/data/)
* Report: [link to our report]()
* Website: [you're on it right now](share.streamlit.io/vincentwi/streamlit-example)
* Further Reading: 
        + [IMPROVING EQUALITY OF OPPORTUNITY: NEW INSIGHTS FROM BIG DATA](https://onlinelibrary.wiley.com/doi/10.1111/coep.12478) [via CS](https://onlinelibrary-wiley-com.ezproxy.universite-paris-saclay.fr/doi/pdf/10.1111/coep.12478)
        + [Mobility Report Cards: The Role of Colleges in Intergenerational Mobility](https://opportunityinsights.org/wp-content/uploads/2018/03/coll_mrc_slides.pdf)


MIT License
Copyright © Vincent Wilmet 2022
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
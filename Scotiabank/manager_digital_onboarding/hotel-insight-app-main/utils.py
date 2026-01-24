"""
Libraries
"""
import streamlit as st
import pandas as pd
import numpy as np
import os, os.path
import warnings
import random
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pickle
import json
import datetime
from datetime import datetime
import time


"""
App Information
"""
APP_NAME = 'Boutique Hotel Analytics'
ABOUT_HEADER = 'About'
DASHBOARD_HEADER = 'Hotel Insights'
APP_FILTERS = 'Filters'
NO_DATA_INFO = 'No data available to display based on the filters'

warnings.simplefilter(action='ignore', category=FutureWarning)
st.set_page_config(
    page_title=APP_NAME,
    layout="wide"
)
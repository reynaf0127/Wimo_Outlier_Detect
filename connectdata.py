import pandas as pd
import numpy as np
import datetime as dt
import matplotlib as mp
import scipy as scipy
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import date
from scipy.stats import shapiro
import vertica_python

exec(open('./sql.py').read())

conn_info = {'host': '23.20.153.208',
             'port': 5433,
             'user': 'dbadmin',
             'password': 'Welcome$6060$',
             'database': 'Verticadb',
             'unicode_error': 'strict',
             'ssl': False,
             'autocommit': True,
             'use_prepared_statements': False,
             'connection_timeout': 200
    }
with vertica_python.connect(**conn_info) as conn:
    cur = conn.cursor()
    cur.execute(sale_sql)
    sale=cur.fetchall()
    num_fields = len(cur.description)
    field_names = [i[0] for i in cur.description]
    conn.close()
sale_data=pd.DataFrame(sale)

with vertica_python.connect(**conn_info) as conn:
    cur = conn.cursor()
    cur.execute(currency_sql)
    currency=cur.fetchall()
    num_fields = len(cur.description)
    field_names = [i[0] for i in cur.description]
    conn.close()
currency_data=pd.DataFrame(currency)
sale_file='sale_%s.csv' %(supportid)
currency_file='currency_%s.csv' %(supportid)
sale_data.to_csv(sale_file)
currency_data.to_csv(currency_file)
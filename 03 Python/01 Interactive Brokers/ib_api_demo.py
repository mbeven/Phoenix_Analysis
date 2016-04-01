# -*- coding: utf-8 -*-
"""
Created on Mon Mar 21 15:36:39 2016

@author: michaelbeven

Using Python, IBPy and the Interactive Brokers API to Automate Trades

https://www.quantstart.com/articles/using-python-ibpy-and-the-interactive-brokers-api-to-automate-trades

In the following implementation we are going to create an extremely simple example, which will simply send 
a single market order to buy 100 units of Google stock, using smart order routing. The latter is designed 
to achieve the best price in practice, although in certain situations it can be suboptimal. However for the 
purposes of this tutorial it will suffice.
"""

from ib.ext.Contract import Contract
from ib.ext.Order import Order
from ib.opt import Connection

def error_handler(msg):
    """Handles the capturing of error messages"""
    print (("Server Error: %s") % msg)

def reply_handler(msg):
    """Handles of server replies"""
    print (("Server Response: %s, %s") % (msg.typeName, msg))
    
def create_contract(symbol, sec_type, exch, prim_exch, curr):
    """Create a Contract object defining what will
    be purchased, at which exchange and in which currency.

    symbol - The ticker symbol for the contract
    sec_type - The security type for the contract ('STK' is 'stock')
    exch - The exchange to carry out the contract on
    prim_exch - The primary exchange to carry out the contract on
    curr - The currency in which to purchase the contract"""
    contract = Contract()
    contract.m_symbol = symbol
    contract.m_secType = sec_type
    contract.m_exchange = exch
    contract.m_primaryExch = prim_exch
    contract.m_currency = curr
    return contract

def create_order(order_type, quantity, action, account):
    """Create an Order object (Market/Limit) to go long/short.

    order_type - 'MKT', 'LMT' for Market or Limit orders
    quantity - Integral number of assets to order
    action - 'BUY' or 'SELL'"""
    order = Order()
    order.m_orderType = order_type
    order.m_totalQuantity = quantity
    order.m_action = action
    order.m_account = account
    return order
    
# ib_api_demo.py

if __name__ == "__main__":
    # Connect to the Trader Workstation (TWS) running on the
    # usual port of 7497, with a clientId of 000
    # (The clientId is chosen by us and we will need 
    # separate IDs for both the execution connection and
    # market data connection)
    tws_conn = Connection.create(port=7497, clientId=000)
    tws_conn.connect()

    # Assign the error handling function defined above
    # to the TWS connection
    tws_conn.register(error_handler, 'Error')

    # Assign all of the server reply messages to the
    # reply_handler function defined above
    tws_conn.registerAll(reply_handler)

    # Create an order ID which is 'global' for this session. This
    # will need incrementing once new orders are submitted.
    order_id = 503 # has to change each time

    # Create a contract in GOOG stock via SMART order routing
    my_contract = create_contract('GOOG', 'STK', 'SMART', 'SMART', 'USD')

    # Go long 100 shares of Google
    my_order = create_order('MKT', 100, 'BUY', 'DU365775') # my account tag in top right of GUI

    # Use the connection to the send the order to IB
    tws_conn.placeOrder(order_id, my_contract, my_order)

    # Disconnect from TWS
    tws_conn.disconnect()
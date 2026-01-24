from utils import *
from data import *

st.title(APP_NAME)
st.header(DASHBOARD_HEADER)


with st.sidebar:
    month_option = st.multiselect("Month", month_list,default=month_list)
    room_type_option = st.multiselect("Room Type",room_type_list, default=room_type_list)
    request_type_option = st.multiselect("Room Request",request_type_list, default=request_type_list)

# load intgrated df * filter
integrated_bookings_df2 = integrated_bookings_df[
    (integrated_bookings_df['booking_month'].isin(month_option)) & 
    (integrated_bookings_df['room type'].isin(room_type_option)) & 
    (integrated_bookings_df['request type'].isin(request_type_option))
]

integrated_bookings_df2['booking_revenue'] = integrated_bookings_df2['stay_duration'] * integrated_bookings_df2['price/day']
total_room_nights_sold = integrated_bookings_df2['stay_duration'].sum()
min_start_date = integrated_bookings_df2['start date_x'].min()
max_end_date = integrated_bookings_df2['end date_x'].max()
total_days_in_period = (max_end_date - min_start_date).days + 1
total_unique_rooms = integrated_bookings_df2['room'].nunique()
total_available_room_nights = total_unique_rooms * total_days_in_period
occupancy_rate = total_room_nights_sold / total_available_room_nights
print(f"Occupancy Rate: {occupancy_rate:.2%}")
adr = integrated_bookings_df2['booking_revenue'].sum() / total_room_nights_sold
print(f"Average Daily Rate (ADR): ${adr:.2f}")
revpar = integrated_bookings_df2['booking_revenue'].sum() / total_available_room_nights
print(f"Revenue Per Available Room (RevPAR): ${revpar:.2f}")
total_requests = requests_df['request id'].nunique()
fulfilled_requests = bookings_df['request id'].nunique()
request_fulfillment_rate = fulfilled_requests / total_requests
print(f"Request Fulfillment Rate: {request_fulfillment_rate:.2%}")
average_length_of_stay = integrated_bookings_df2['stay_duration'].mean()
print(f"Average Length of Stay: {average_length_of_stay:.2f} days")



st.subheader("KPIs")
col1, col2, col3, col4 = st.columns(4)
with col1:
    st.metric(label="Occupancy Rate", value=f"{occupancy_rate:.2%}")
with col2:
    st.metric(label="Average Daily Rate (ADR)", value=f"${adr:.2f}")
with col3:
    st.metric(label="Revenue Per Available Room (RevPAR)", value=f"${revpar:.2f}")
with col4:
    st.metric(label="Average Length of Stay", value=f"{average_length_of_stay:.2f}")

tab1, tab2, tab3 = st.tabs(["Booking",'Request Type', "Room Type"])

with tab1:
    st.subheader("Booking Trends")
    monthly_booking_trends = integrated_bookings_df2.groupby('booking_month').agg(
    total_booking_revenue=('booking_revenue', 'sum'),
    total_bookings=('id_x', 'count'),
    average_stay_duration=('stay_duration', 'mean')
    )
    # Define the chronological order of months
    month_order = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    # Prepare the DataFrame for plotting: reset index and convert 'booking_month' to a categorical type with ordered categories
    monthly_booking_trends_plot = monthly_booking_trends.reset_index()
    monthly_booking_trends_plot['booking_month'] = pd.Categorical(monthly_booking_trends_plot['booking_month'], categories=month_order, ordered=True)
    monthly_booking_trends_plot = monthly_booking_trends_plot.sort_values('booking_month')

    fig_revenue = px.line(monthly_booking_trends_plot,
                      x='booking_month',
                      y='total_booking_revenue',
                      title='Total Booking Revenue by Month',
                      labels={'booking_month': 'Booking Month', 'total_booking_revenue': 'Total Revenue'},
                      markers=True)
    fig_revenue.update_layout(xaxis_title='Booking Month', yaxis_title='Total Revenue', margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_revenue) #fig_revenue.show()

    fig_bookings = px.line(monthly_booking_trends_plot,
                       x='booking_month',
                       y='total_bookings',
                       title='Total Number of Bookings by Month',
                       labels={'booking_month': 'Booking Month', 'total_bookings': 'Total Bookings'},
                       markers=True)
    fig_bookings.update_layout(xaxis_title='Booking Month', yaxis_title='Total Bookings', margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_bookings)

    fig_stay_duration = px.line(monthly_booking_trends_plot,
                            x='booking_month',
                            y='average_stay_duration',
                            title='Average Stay Duration by Month',
                            labels={'booking_month': 'Booking Month', 'average_stay_duration': 'Average Stay Duration (Days)'},
                            markers=True)
    fig_stay_duration.update_layout(xaxis_title='Booking Month', yaxis_title='Average Stay Duration (Days)', margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_stay_duration)

with tab2:
    st.subheader("Request Trends")
    request_type_performance = integrated_bookings_df2.groupby('request type').agg(
    total_booking_revenue=('booking_revenue', 'sum'),
    average_stay_duration=('stay_duration', 'mean'),
    average_total_guests=('total_guests', 'mean')
    )

    fig_revenue_request = px.bar(request_type_performance.reset_index(),
                             x='total_booking_revenue',
                             y='request type',
                             orientation='h',
                             title='Total Booking Revenue by Request Type',
                             labels={'total_booking_revenue': 'Total Revenue', 'request type': 'Request Type'},
                             color_discrete_sequence=['deepskyblue'])
    fig_revenue_request.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_revenue_request)

    fig_stay_duration_request = px.bar(request_type_performance.reset_index(),
                                   x='average_stay_duration',
                                   y='request type',
                                   orientation='h',
                                   title='Average Stay Duration by Request Type',
                                   labels={'average_stay_duration': 'Average Stay Duration (Days)', 'request type': 'Request Type'},
                                   color_discrete_sequence=['lightcoral'])
    fig_stay_duration_request.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_stay_duration_request)

    fig_guests_request = px.bar(request_type_performance.reset_index(),
                            x='average_total_guests',
                            y='request type',
                            orientation='h',
                            title='Average Guests by Request Type',
                            labels={'average_total_guests': 'Average Total Guests', 'request type': 'Request Type'},
                            color_discrete_sequence=['mediumseagreen'])
    fig_guests_request.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_guests_request)


with tab3:
    st.subheader("Room Type Trends")
    room_type_performance = integrated_bookings_df.groupby('room type').agg(
        total_booking_revenue=('booking_revenue', 'sum'),
        average_price_per_day=('price/day', 'mean'),
        average_total_guests=('total_guests', 'mean')
    )
    fig_revenue_room = px.bar(room_type_performance.reset_index(),
                          x='total_booking_revenue',
                          y='room type',
                          orientation='h',
                          title='Total Booking Revenue by Room Type',
                          labels={'total_booking_revenue': 'Total Revenue', 'room type': 'Room Type'},
                          color_discrete_sequence=['dodgerblue'])
    fig_revenue_room.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_revenue_room)

    fig_price_room = px.bar(room_type_performance.reset_index(),
                        x='average_price_per_day',
                        y='room type',
                        orientation='h',
                        title='Average Price per Day by Room Type',
                        labels={'average_price_per_day': 'Average Price per Day', 'room type': 'Room Type'},
                        color_discrete_sequence=['orange'])
    fig_price_room.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_price_room)

    fig_guests_room = px.bar(room_type_performance.reset_index(),
                         x='average_total_guests',
                         y='room type',
                         orientation='h',
                         title='Average Total Guests by Room Type',
                         labels={'average_total_guests': 'Average Total Guests', 'room type': 'Room Type'},
                         color_discrete_sequence=['green'])
    fig_guests_room.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
    st.plotly_chart(fig_guests_room)

#with tab4:
#    st.subheader("Food & Beverage Trends")
#    menu_item_value = integrated_food_orders_df.groupby('name')['order_value'].sum().nlargest(5)
##    fig_menu_items = px.bar(menu_item_value.reset_index(),
#                        x='order_value',
#                        y='name',
#                        orientation='h',
#                        title='Top 5 Most Popular Menu Items by Order Value',
#                        labels={'name': 'Menu Item', 'order_value': 'Total Order Value'},
#                        color_discrete_sequence=px.colors.qualitative.Vivid)
#    fig_menu_items.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
#    st.plotly_chart(fig_menu_items)

#    fig_food_categories = px.bar(food_category_value.reset_index(),
#                             x='order_value',
#                             y='category',
#                             orientation='h',
#                             title='Top 5 Most Popular Food Categories by Order Value',
#                             labels={'category': 'Food Category', 'order_value': 'Total Order Value'},
#                             color_discrete_sequence=px.colors.qualitative.Bold)
#fig_food_categories.update_layout(yaxis={'categoryorder':'total ascending'}, margin=dict(l=10, r=10, t=40, b=10), template='plotly_white', title_x=0.5, height=450)
#fig_food_categories.show()



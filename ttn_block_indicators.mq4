//+------------------------------------------------------------------+
//|                                                  TitansBlock.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

input color ttn_monthly_color=clrRoyalBlue;
input color ttn_weekly_color= clrLime;
input color ttn_daily_color= clrCrimson;

input ENUM_LINE_STYLE ttn_monthly_st = STYLE_SOLID;
input ENUM_LINE_STYLE ttn_weekly_st = STYLE_SOLID;
input ENUM_LINE_STYLE ttn_daily_st = STYLE_SOLID;





//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping

//---

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
   int bars=0;
   if(prev_calculated>0) {
      bars= rates_total - (prev_calculated -1);
   } else {
      bars = rates_total - 1;
   }
   //**@TODO: create TTN_block_monthly
   if(Period()==PERIOD_D1) {
      int i=bars;
      while(i>0) {
         datetime start_time=time[i];
         double start_price = open[i];
         int j=i;
         while(j>0 && TimeMonth(time[j])==TimeMonth(start_time)) {
            j--;
         }
         datetime end_time= time[j];
         double end_price = open[j];
         createBlock(0,"TTN Block Monthly"+i,0,start_time,start_price,end_time,end_price,ttn_monthly_color,ttn_monthly_st,1,false,false,false,true,0);
         i=j;
      }
   }
   //**@TODO: Create TTN_block weekly
   if(Period()==PERIOD_H4){
      int i=bars;
      while(i>0){
         datetime start_time=time[i];
         double start_price = open[i];
         int j=i;
         int cpt=0;
         while(j>0 && TimeMonth(time[j])== TimeMonth(start_time)){
            for(int k=j; j>0 ; )
         }   
      }
   }

//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

//** @TODO: Create rectangle function
bool createBlock(const long chart_ID=0,
                 const string name="TTN block",
                 const int sub_windows=0,
                 datetime time1=0,
                 double price1=0,
                 datetime time2=0,
                 double price2=0,
                 const color clr=clrRed,
                 const ENUM_LINE_STYLE style=STYLE_SOLID,
                 const int width=1,
                 const bool fill=false,
                 const bool back = false,
                 const bool selection= true,
                 const bool hidden= true,
                 const long z_order=0)
{
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,0,time1,price1,time2,price2)) {
      Print(__FUNCTION__,"Failed to create block");
      return(false);
   } else {
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID, name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
      ObjectSetInteger(chart_ID,name,OBJPROP_FILL, fill);
      ObjectSetInteger(chart_ID,name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER,z_order);
      Comment("Block Created");
      return(true);
   }
}

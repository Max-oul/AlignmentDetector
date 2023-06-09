//+------------------------------------------------------------------+
//|                                         AlignementDetectorv1.mq4 |
//|                              Copyright 2023, Anjaramamy Liantsoa |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Anjaramamy Liantsoa"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_color1 LimeGreen
#property indicator_color2 Red
#property indicator_color3 Yellow
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int Monthly_Trend, Weekly_Trend, Yesterday_Trend;
int OnInit() {
   IndicatorShortName("MTF Trend");
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   // Déterminer la tendance pour chaque période de temps
   double First_Close = iClose(NULL, PERIOD_D1, 0);
   double First_Open = iOpen(NULL, PERIOD_D1, 0);
   double Yesterday_Close = iClose(NULL, PERIOD_D1, 1);
   double Yesterday_Open = iOpen(NULL, PERIOD_D1, 1);
   double Weekly_Close = iClose(NULL, PERIOD_W1, 0);
   double Weekly_Open = iOpen(NULL, PERIOD_W1, 0);
   double Monthly_Close = iClose(NULL, PERIOD_MN1, 0);
   double Monthly_Open = iOpen(NULL, PERIOD_MN1, 0);


   Monthly_Trend = First_Close > Monthly_Open ? 1 : (First_Close < Monthly_Open ? -1 : 0);
   Weekly_Trend = First_Close > Weekly_Open ? 1 : (First_Close < Weekly_Open ? -1 : 0);
   Yesterday_Trend = First_Close > Yesterday_Open ? 1 : (First_Close < Yesterday_Open ? -1 : 0);
   // Afficher les tendances dans la partie supérieure gauche du graphique
   ObjectCreate("MTF Trend Label", OBJ_LABEL, 0, 0, 0);
   ObjectSet("MTF Trend Label", OBJPROP_CORNER, 0);
   ObjectSet("MTF Trend Label", OBJPROP_XDISTANCE, 10);
   ObjectSet("MTF Trend Label", OBJPROP_YDISTANCE, 20);
   ObjectSetText("MTF Trend Label", "Monthly " + GetTrendText(Monthly_Trend) + ", Weekly " + GetTrendText(Weekly_Trend) + ", Yesterday " + GetTrendText(Yesterday_Trend), 12, "Arial", LimeGreen);

   // Liste de toutes les paires de devises dans le serveur
   // Supposons un maximum de 100 paires
   int nb_pairs = SymbolsTotal(true);
   string pairs[];
   ArrayResize(pairs,nb_pairs);
   for (int i = 0; i < nb_pairs; i++) {
      pairs[i] = SymbolName(i, true);
   }
   // Filtrer les paires de devises en fonction de l'alignement de tendance
   int nb_pairs_filtered = 0;
   string pairs_filtered[];
   ArrayResize(pairs_filtered,nb_pairs);
   for (int i = 0; i < nb_pairs; i++) {
      double close = iClose(pairs[i], PERIOD_D1, 0);
      double open = iOpen(pairs[i], PERIOD_D1, 0);
      double yesterday_close = iClose(pairs[i], PERIOD_D1, 1);
      double yesterday_open = iOpen(pairs[i], PERIOD_D1, 1);
      double weekly_close = iClose(pairs[i], PERIOD_W1, 0);
      double weekly_open = iOpen(pairs[i], PERIOD_W1, 0);
      double monthly_close = iClose(pairs[i], PERIOD_MN1, 0);
      double monthly_open = iOpen(pairs[i], PERIOD_MN1, 0);

      int monthly_trend = close > monthly_open ? 1 : (close < monthly_open ? -1 : 0);
      int weekly_trend = close > weekly_open ? 1 : (close < weekly_open ? -1 : 0);
      int yesterday_trend = close > yesterday_open ? 1 : (close < yesterday_open ? -1 : 0);

      if ((monthly_trend == 1 && weekly_trend == 1 && yesterday_trend == 1)||(monthly_trend == 0 && weekly_trend == 0 && yesterday_trend == 0)) {
         pairs_filtered[nb_pairs_filtered] = pairs[i];
         nb_pairs_filtered++;
      }
   }

   // Afficher les paires de devises filtrées dans la partie supérieure droite du graphique
   string pairs_text = "";
   for (int i = 0; i < nb_pairs_filtered; i++) {
      pairs_text = pairs_text + pairs_filtered[i] + " ";
   }
   ObjectCreate("Pairs Label", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Pairs Label", OBJPROP_CORNER, 1);
   ObjectSet("Pairs Label", OBJPROP_XDISTANCE, 10);
   ObjectSet("Pairs Label", OBJPROP_YDISTANCE, 20);
   ObjectSetText("Pairs Label", pairs_text, 12, "Arial", Black);

   return(0);
}

//---- Fonction pour obtenir le texte de la tendance
string GetTrendText(int Trend) {
   if (Trend == 1) {
      return "Up";
   } else if (Trend == -1) {
      return "Down";
   } else {
      return "Flat";
   }
}

//+------------------------------------------------------------------+

class GlobalMarketData{
  final Map<String, double> totalMarketCap;
  final Map<String, double> totalVolume;
  final double marketCapChangePercentage24hUsd;

    const GlobalMarketData({
      required this.totalMarketCap,
      required this.totalVolume,
      required this.marketCapChangePercentage24hUsd,
  });
}
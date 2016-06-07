package com.svm.webservices;

import java.util.HashMap;

public class TestClient {

	public static void main(String[] args) {
		StockDataFetcher fetcher = new StockDataFetcher();
		HashMap<String, String> retVal = fetcher.getStockDataForFiveYears("YHOO");
		System.out.println("*** RetVal: " + retVal);
	}
}

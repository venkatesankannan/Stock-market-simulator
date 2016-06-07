package com.svm.webservices;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import com.svm.constants.URLConstants;

public class StockDataFetcher {

	public String getStockData(String symbol) {
		HttpURLConnection stockUrlConnection = null;
		Date date = new Date();
		String retVal = null;
		InputStream weatherDataIs = null;
		try {
			StringBuilder stockString = new StringBuilder();
			stockString.append(URLConstants.STOCK_URL).append(symbol);
			stockString.append(URLConstants.TO_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.TO_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.TO_YEAR).append(Calendar.getInstance().get(Calendar.YEAR));
			stockString.append(URLConstants.DATA_KIND);
			stockString.append(URLConstants.FROM_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.FROM_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.FROM_YEAR).append(Calendar.getInstance().get(Calendar.YEAR - 1));
			stockString.append(URLConstants.IGONORE_CSS);

			System.out.println("Input String: " + stockString.toString());

			stockUrlConnection = (HttpURLConnection) (new URL(stockString.toString())).openConnection();
			stockUrlConnection.setDoInput(true);
			stockUrlConnection.setRequestMethod("GET");
			stockUrlConnection.setDoOutput(true);
			stockUrlConnection.connect();

			String cvsSplitBy = ",";

			/*
			 * Response is got here after talking to the URL specified
			 */
			StringBuilder responseBuffer = new StringBuilder();
			weatherDataIs = stockUrlConnection.getInputStream();
			BufferedReader urlBufferReader = new BufferedReader(new InputStreamReader(weatherDataIs));
			String format = "dd-MM-YYYY";

			String line = null;
			int counter = 0;
			while ((line = urlBufferReader.readLine()) != null) {
				String[] value = line.split(cvsSplitBy);
				System.out.println("*** value[0]: " + value[0]);
				System.out.println("*** value[1]: " + value[1]);

				if (counter == 1) {
					retVal = value[0] + "," + value[1] + "," + value[2] + "," + value[3] + "," + value[4] + "," + value[5] + "," + value[6];
					break;
				}
				counter++;
			}

			weatherDataIs.close();
			stockUrlConnection.disconnect();
			return retVal;
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				weatherDataIs.close();
				stockUrlConnection.disconnect();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
		return null;
	}

	public HashMap<String, String> getStockDataForFiveYears(String symbol) {

		HttpURLConnection stockUrlConnection = null;
		Date date = new Date();
		HashMap<String, String> retVal = new HashMap<String, String>();
		InputStream weatherDataIs = null;
		try {
			int calYear = Calendar.getInstance().get(Calendar.YEAR);
			StringBuilder stockString = new StringBuilder();
			stockString.append(URLConstants.STOCK_URL).append(symbol);
			stockString.append(URLConstants.TO_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.TO_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.TO_YEAR).append(Calendar.getInstance().get(Calendar.YEAR));
			stockString.append(URLConstants.DATA_KIND);
			stockString.append(URLConstants.FROM_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.FROM_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.FROM_YEAR).append(calYear - 2);
			stockString.append(URLConstants.IGONORE_CSS);

			System.out.println("Input String: " + stockString.toString());

			stockUrlConnection = (HttpURLConnection) (new URL(stockString.toString())).openConnection();
			stockUrlConnection.setDoInput(true);
			stockUrlConnection.setRequestMethod("GET");
			stockUrlConnection.setDoOutput(true);
			stockUrlConnection.connect();

			String cvsSplitBy = ",";

			/*
			 * Response is got here after talking to the URL specified
			 */
			StringBuilder responseBuffer = new StringBuilder();
			weatherDataIs = stockUrlConnection.getInputStream();
			BufferedReader urlBufferReader = new BufferedReader(new InputStreamReader(weatherDataIs));
			String format = "dd-MM-YYYY";

			String line = null;
			int counter = 0;
			while ((line = urlBufferReader.readLine()) != null) {
				String[] value = line.split(cvsSplitBy);
				System.out.println("*** value[0]: " + value[0]);
				System.out.println("*** value[1]: " + value[1]);
				if (counter != 0)
					retVal.put(value[0], value[1] + "," + value[2] + "," + value[3] + "," + value[4] + "," + value[5] + "," + value[6]);

				counter++;
			}

			weatherDataIs.close();
			stockUrlConnection.disconnect();
			return retVal;
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				weatherDataIs.close();
				stockUrlConnection.disconnect();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
		return null;

	}

	public HashMap<String, String> getStockDataForWeek(String symbol) {
		HttpURLConnection stockUrlConnection = null;
		Date date = new Date();
		HashMap<String, String> retVal = new HashMap<String, String>();
		InputStream weatherDataIs = null;
		try {
			StringBuilder stockString = new StringBuilder();
			stockString.append(URLConstants.STOCK_URL).append(symbol);
			stockString.append(URLConstants.TO_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.TO_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.TO_YEAR).append(Calendar.getInstance().get(Calendar.YEAR));
			stockString.append(URLConstants.DATA_KIND);
			stockString.append(URLConstants.FROM_MONTH).append(Calendar.getInstance().get(Calendar.MONTH));
			stockString.append(URLConstants.FROM_DAY).append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
			stockString.append(URLConstants.FROM_YEAR).append(Calendar.getInstance().get(Calendar.YEAR - 1));
			stockString.append(URLConstants.IGONORE_CSS);

			System.out.println("Input String: " + stockString.toString());

			stockUrlConnection = (HttpURLConnection) (new URL(stockString.toString())).openConnection();
			stockUrlConnection.setDoInput(true);
			stockUrlConnection.setRequestMethod("GET");
			stockUrlConnection.setDoOutput(true);
			stockUrlConnection.connect();

			String cvsSplitBy = ",";

			/*
			 * Response is got here after talking to the URL specified
			 */
			StringBuilder responseBuffer = new StringBuilder();
			weatherDataIs = stockUrlConnection.getInputStream();
			BufferedReader urlBufferReader = new BufferedReader(new InputStreamReader(weatherDataIs));
			String format = "dd-MM-YYYY";

			String line = null;
			int counter = 0;
			while ((line = urlBufferReader.readLine()) != null) {
				String[] value = line.split(cvsSplitBy);
				System.out.println("*** value[0]: " + value[0]);
				System.out.println("*** value[1]: " + value[1]);
				if (counter != 0)
					retVal.put(value[0], value[6]);
				if (counter == 7) {
					break;
				}

				counter++;
			}

			weatherDataIs.close();
			stockUrlConnection.disconnect();
			return retVal;
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				weatherDataIs.close();
				stockUrlConnection.disconnect();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
		return null;
	}
}

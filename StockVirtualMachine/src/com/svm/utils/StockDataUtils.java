package com.svm.utils;

import java.math.BigDecimal;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.TreeMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class StockDataUtils {

	static HashMap<String, Double> returnMap = new HashMap<String, Double>();

	private static double getTodayCost(String stockSymbol) {

		try {
			String url = "http://dev.markitondemand.com/Api/Quote?symbol=" + stockSymbol;
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document dom = db.parse(new InputSource(new URL(url).openStream()));
			Element root = dom.getDocumentElement();
			NodeList quote = root.getElementsByTagName("Data");
			if (null != quote && quote.getLength() > 0) {

				Element data = (Element) quote.item(0);
				String lastVal = data.getFirstChild().getNodeName();
				Element item = (Element) quote.item(0).getChildNodes().item(3);
				String retValString = item.getTextContent();
				double retValDouble = Double.parseDouble(retValString);
				return retValDouble;

			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return 0.0;
		}
		return 0.0;

	}

	private Map<String, Double> sortList(HashMap<String, Double> returnMap) {
		List<Entry<String, Double>> list = new LinkedList<Entry<String, Double>>(returnMap.entrySet());
		Collections.sort(list, new Comparator<Entry<String, Double>>() {
			public int compare(Entry<String, Double> o1, Entry<String, Double> o2) {
				return o2.getValue().compareTo(o1.getValue());
			}
		});

		Map<String, Double> sortedMap = new LinkedHashMap<String, Double>();
		for (Entry<String, Double> entry : list) {
			sortedMap.put(entry.getKey(), entry.getValue());
		}

		Map<String, Double> finalMap = new LinkedHashMap<String, Double>();
		int count = 0;
		for (Map.Entry<String, Double> entry : sortedMap.entrySet()) {
			if (count >= 5)
				break;
			finalMap.put(entry.getKey(), entry.getValue());
			count++;
		}
		return finalMap;
	}

	public static LinkedHashMap<String, Double> fetchTopFivePerformers() {
		LinkedHashMap<String, Double> sortedMap = null;
		ArrayList<Double> returnList = new ArrayList<Double>();
		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("select * from svm.\"UserStockData\";");
			double todayPrice = 0;
			String stockSymbol = "";
			double stockReturn = 0.0;
			double costPrice = 0.0;
			String userName = "";

			while (rs.next()) {
				costPrice = Double.parseDouble(rs.getString(4));
				stockSymbol = rs.getString(2);
				todayPrice = getTodayCost(stockSymbol);
				stockReturn = todayPrice - costPrice;

				Double truncatedDouble = new BigDecimal(stockReturn).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
				stockReturn = truncatedDouble.doubleValue();
				userName = rs.getString(1);
				returnList.add(stockReturn);
				returnMap.put(userName, stockReturn);
			}
			Collections.sort(returnList);
			Collections.reverse(returnList);
			StockDataUtils utils = new StockDataUtils();
			sortedMap = (LinkedHashMap<String, Double>) utils.sortList(returnMap);
			System.out.println("*** sortedMap: " + sortedMap);
			/*
			 * for (Entry<String, Double> entry : sortedMap.entrySet()) { String
			 * key = entry.getKey(); String[] splitKey = key.split(","); String
			 * newKey = splitKey[0]; System.out.println("** New Key: " + key);
			 * sortedMap.put(newKey, entry.getValue()); sortedMap.remove(key);
			 * System.out.println("*** sortedMap: " + sortedMap); }
			 */
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return sortedMap;
	}

}

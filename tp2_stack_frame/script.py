import requests
import ctypes
import subprocess

lib = ctypes.CDLL('./converter.so')

lib.process_gini.argtypes = [ctypes.c_float]
lib.process_gini.restype = ctypes.c_int

url = "https://api.worldbank.org/v2/en/country/all/indicator/SI.POV.GINI?format=json&date=2011:2020&per_page=32500&page=1&country=%22Argentina%22"

response = requests.get(url)

if response.status_code == 200:
    data = response.json()

    if len(data) > 1 and isinstance(data[1], list):
        gini_values = data[1]

        unique_years = set()
        gini_filtered = []

        for entry in gini_values:
            country = entry.get("country", {}).get("value", "")
            year = entry.get("date", "")
            gini_value = entry.get("value", None)

            if country == "Argentina" and gini_value is not None and year not in unique_years:
                unique_years.add(year)
                gini_filtered.append(entry)
    
        for entry in gini_filtered:
            gini_original = float(entry["value"])
            gini_modificado = lib.process_gini(gini_original)
            print(f"Año: {entry['date']}, Gini Original: {gini_original}, Gini Modificado: {gini_modificado}")
            notification = f"Año: {entry['date']}, Gini Original: {gini_original}, Gini Modificado: {gini_modificado}"
            subprocess.run(["curl", "-d", str(notification), "ntfy.sh/SegFault"])
    else:
        print("No hay datos")
else:
    print("Error al leer datos")
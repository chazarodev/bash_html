#!/bin/bash

# Este programa parsea los resultados de nmap y construye un documento HTML

titulo="Resultados nmap"
FECHA_ACTUAL="$(date)"
TIMESTAMP="Informe generado el $FECHA_ACTUAL por el usuario $USER"

nmap_exec () {
    echo "[INFO] Ejecutando nmap en la red $1, por favor espere unos segundos..."
    sudo nmap -sV $1 > $2
    echo "[OK] Fichero $2 generado correctamente"
}

generar_reporte () {
    # Generamos el reporte raw con nmap
    nmap_exec $1 $2
    # Dividimos el fichero por líneas vacías
    echo "[INFO] Estamos dividiendo el fichero $2..."
    csplit $2 '/^$/' {*} > /dev/null
    echo "[OK] Fichero $2 dividido en los siguientes ficheros: $(ls xx*)"
}

if [ $(find $2 -mmin -30) ]; then
    while true; do
	read -p "Existe $2 con antiguedad menor a 30 minutos. Sobreescribir? [y/n]: "
	case "$REPLY" in
	    y) generar_reporte $1 $2
	       break
	       ;;
	    n)
	       echo "Utilizando el fichero $2 existente"
	       break
	       ;;
	esac
    done
else
    generar_reporte $1 $2
fi
    
# Generamos el reporte con los resultados de nmap en HTML
echo "[INFO] Generando el reporte HTML"
# Importa el archivo que genera el reporte HTML
source html_report.sh
#Genera el reporte HTML
generar_html > resultados_nmap.html
echo "[OK] Reporte resultados.html generado correctamente"

    


Class BO.Reservation Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method creerReservationVoiture(pRequest As msg.creerVoitureReservationDmde, Output pResponse As msg.creerVoitureReservationRpse) As %Status
{
    Set pResponse = ##class(msg.creerVoitureReservationRpse).%New()
    Set sql = "select plaque from data.Voiture where categorie = '"_pRequest.categorie_"'and plaque not in ("
    Set sql = sql_"SELECT plaque FROM data.Reservation where categorie = '"_pRequest.categorie_"'"
    Set sql = sql_" and ((dateDebut >= '"_pRequest.dateDebut_"' and dateDebut <= '"_pRequest.dateFin_"' ) "
    Set sql = sql_" or (dateFin >= '"_pRequest.dateDebut_"' and dateFin <= '"_pRequest.dateFin_"' ) "
    Set sql = sql_" or (dateDebut <= '"_pRequest.dateDebut_"' and dateFin >= '"_pRequest.dateFin_"' ) "
    Set sql = sql_" or (dateDebut >= '"_pRequest.dateDebut_"' and dateFin <= '"_pRequest.dateFin_"' ))) "
    Set statement = ##class(%SQL.Statement).%New()
    Do statement.%Prepare(sql)
    Set SQLrequest = statement.%Execute()
    Do SQLrequest.%Next()
    Set plaque = SQLrequest.%Get("plaque")
    If (plaque){
    Set idVoiture = ##class(data.Voiture).consulterParPlaqueExists(plaque)
    Set dataVoiture = ##class(data.Voiture).%OpenId(idVoiture)
    Set reservation = ##class(data.Reservation).%New()
    Set reservation.categorie = dataVoiture.categorie
    Set reservation.plaque = dataVoiture.plaque
    Set reservation.dateDebut = pRequest.dateDebut
    Set reservation.dateFin = pRequest.dateFin
    Set tsc = reservation.%Save()
    If (tsc){
        Set pResponse.codeRetour = "OK"
    }
    Else {
        Set pResponse.codeRetour = "KO"
    }
    }
    Else {
        Set pResponse.codeRetour = "KO"
    }
    
    
    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="msg.creerVoitureReservationDmde">
        <Method>creerReservationVoiture</Method>
    </MapItem>
</MapItems>
}

}

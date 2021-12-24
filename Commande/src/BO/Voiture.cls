Class BO.Voiture Extends Ens.BusinessOperation
{

Property Adapter As Ens.OutboundAdapter;

Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method creerVoiture(pRequest As msg.creerVoitureDmde, Output pResponse As msg.creerVoitureRpse) As %Status
{
    
    Set pResponse = ##class(msg.creerVoitureRpse).%New()
    Set voiture = ##class(data.Voiture).%New()
    Do ##class(Transform.WsVoitureToVoiture).Transform(pRequest.voiture,.voiture)
    Set tsc = voiture.%Save()

    Set pResponse.codeRetour = "OK"

    Quit $$$OK
}

Method supprimerVoiture(pRequest As msg.supprimerVoitureDmde, Output pResponse As msg.supprimerVoitureRpse) As %Status
{
    Set pResponse = ##class(msg.supprimerVoitureRpse).%New()
    If (##class(data.Voiture).consulterParPlaqueExists(pRequest.plaque, .idVoiture)){
        Set tsc = ##class(data.Voiture).%DeleteId(idVoiture)
        If 'tsc{
            Set pResponse.codeRetour = "KO"
            Set pResponse.libErreur = "Erreur technique"
            Quit $$$OK 
        } 
    } Else {
            Set pResponse.codeRetour = "KO"
            Set pResponse.libErreur = "Voiture inexistante"
    }
    Set pResponse.codeRetour = "OK"
    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="msg.creerVoitureDmde">
        <Method>creerVoiture</Method>
    </MapItem>
    <MapItem MessageType="msg.supprimerVoitureDmde">
        <Method>supprimerVoiture</Method>
    </MapItem>
</MapItems>
}

}

Class BO.Voiture Extends Ens.BusinessOperation
{

Property Adapter As Ens.OutboundAdapter;

Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method creerVoiture(pRequest As msg.creerVoitureDmde, Output pResponse As msg.creerVoitureRpse) As %Status
{
    
    Set pResponse = ##class(msg.creerVoitureRpse).%New()
    Set voiture = ##class(data.Voiture).%New()
    Set voiture.nom = pRequest.nom
    Set voiture.categorie = pRequest.categorie
    Set voiture.plaque = pRequest.plaque
    Set tsc = voiture.%Save()

    Set pResponse.codeRetour = "OK"

    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="msg.creerVoitureDmde">
        <Method>creerVoiture</Method>
    </MapItem>
</MapItems>
}

}

#Change name of class
class MinlocScraper
  FT_MINERAL_OCCURRENCE_PORTRAYAL = "mo:MinOccView"
  FT_MINERAL_OCCURRENCE = "er:MineralOccurrence"
  
  MINERAL_OCCURRENCE_ID = "er.mineraloccurrence"
  
  GML_ID_XPATH = "/wfs:FeatureCollection/gml:featureMembers/mo:MinOccView/@gml:id"
  
  def initialize

  end
  
  def proxy=(proxy)
    @proxy = proxy
  end
  
  def proxy
    @proxy
  end
	
  
  def create_services(services)
    states = services.keys
    states.each do |state|
	puts state
      s = services[state]
      if !s.nil?
		service=Service.new(s)
		service.create_agent(@proxy)
		if service.feature_type?(FT_MINERAL_OCCURRENCE_PORTRAYAL)
		  response=service.get_features(FT_MINERAL_OCCURRENCE_PORTRAYAL,nil,5)
		  #parse(response, FT_MINERAL_OCCURRENCE_PORTRAYAL)
		  
		else
          occurrence_check(service,state)
		end		
      end
    end
  end

  def parse(response, x=nil)
    
  end
#Get Feature(s) - This gets multiple features
#http://www.mrt.tas.gov.au/web-services/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.1.0&maxFeatures=5&typeName=gsml:MappedFeature

#Get Feature - Gets one feature
#http://www.mrt.tas.gov.au/web-services/wfs?service=WFS&version=1.1.0&request=GetFeature&typeName=gsml:MappedFeature&featureid=gsml.mappedfeature.1
  
  def occurrence_check(service,state)
    occurrence_ids = Occurrence.state(state).pluck(:otherid)
    occurrence_ids.each do |id|
	  unless state == 'WA' 
	    id=id.to_i
	  end
      gmlid =  "#{MINERAL_OCCURRENCE_ID}.#{id}"
      response=service.get_features("er:MineralOccurrence",gmlid)
      minocc = response.xml.search("/wfs:FeatureCollection/gml:featureMembers/er:MineralOccurrence")
      if minocc.empty?
        puts "ID #{id} not found in #{state} service"
	  else
	    #puts "ID #{id} found in #{state} service"
      end
	end
  end
end

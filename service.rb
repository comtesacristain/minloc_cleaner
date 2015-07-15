class Service
  FEATURE_TYPE_XPATH = "/wfs:WFS_Capabilities/wfs:FeatureTypeList/wfs:FeatureType/wfs:Name"
  attr_reader :uri, :capabilities, :agent
  
  def initialize(uri)
	@uri = URI(uri)
  end
  
  def get_capabilities
    if !@agent.nil?
      url = @uri
	  url.query = "request=GetCapabilities"
	  @capabilities = @agent.get(url)
	end
  end
  
  def get_features(feature_type, featureid = nil,  max_features=nil)
	url = @uri
	url.query = "?service=WFS&version=1.1.0&request=GetFeature&typename=#{feature_type}"
	url.query += "&featureid=#{featureid}" unless featureid.nil?
	url.query += "&maxfeatures=#{max_features}" unless max_features.nil?
	return @agent.get(url)
  end
  
  def feature_type?(feature_type)
	if @capabilities.nil?
	  get_capabilities
	end
	feature_types = @capabilities.xml.search(FEATURE_TYPE_XPATH)
	ft_array = feature_types.map { |ft| ft.text}
	if ft_array.include?(feature_type)
	  return true
	else
	  return false
	end
  end
  
  def create_agent(proxy = nil)
    @agent = Mechanize.new do |a|
	  unless proxy.nil?
        a.set_proxy(proxy["address"],proxy["port"],proxy["username"],proxy["password"])
	  end
      a.ssl_version, a.verify_mode = 'SSLv23', OpenSSL::SSL::VERIFY_NONE
	  
    end
  end

end
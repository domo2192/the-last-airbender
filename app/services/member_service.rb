class MemberService

  def self.get_endpoints(nation)
    resp = Faraday.get("https://last-airbender-api.herokuapp.com/api/v1/characters?affiliation=#{nation.gsub('_', '+')}") do |req|
      req.params['perPage'] = 25
  end
    all_members = JSON.parse(resp.body, symbolize_names: true)
    @full_count = []
    @full_count << all_members
    page_num = 1
    until @full_count.length == 96
      page_num += 1
      more_members = next_page(nation, page_num)
      @full_count << more_members
    end
    MemberFacade.get_objects(all_members)
  end

  def self.next_page(nation, page_num)
    resp = Faraday.get("https://last-airbender-api.herokuapp.com/api/v1/characters?affiliation=#{nation.gsub('_', '+')}") do |req|
      req.params['perPage'] = 25
      req.params['page'] = page_num
    end
    all_members = JSON.parse(resp.body, symbolize_names: true)
  end
end

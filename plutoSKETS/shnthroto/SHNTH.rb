require 'sketchup'
#load 'PETERUBYFUNC.rb'

def signale (boundsminx, boundsminy, boundsmaxx, boundsmaxy, zzz)
  prompts = ["DEPTH", "AMOUNT", "Gender"]
 defaults = [".1", "32", "female"]
  input = UI.inputbox prompts, defaults, "Tell me about yourself."
  numseg = Integer(input[1])
  radius = 0.03125
  wire = 0.01
  depth = Float(input[0])
  margin = 0.25
  da = (Math::PI * 2) / (numseg)
  model = Sketchup.active_model
  entities = model.active_entities   

  centerptx = (boundsminx + boundsmaxx) / 2
  centerpty = (boundsminy + boundsmaxy) / 2

  scalex = centerptx - boundsminx - margin
  scaley = centerpty - boundsminy - margin
  lastcosa=0
  lastsina=0
  lengthacc = 0
  for i in 0..(numseg-1) do
    angle = i * da
    cosa = (Math.cos(angle) * (i.divmod(2)[1]+1) / 2)
    sina = (Math.sin(angle) * (i.divmod(2)[1]+1) / 2)
    cosa = (cosa * scalex) + centerptx
    sina = (sina * scaley) + centerpty
    
    centerpoint = Geom::Point3d.new(cosa,sina,zzz) 
    vector = Geom::Vector3d.new 0,0,1
    vector2 = vector.normalize!
    edgesz = entities.add_circle centerpoint, vector2, radius,10
    facc = edgesz[0].faces[0] 
      if !(facc.normal == Geom::Vector3d.new(0,0,1))
          facc.reverse! end
    if (facc) then facc.pushpull -depth end

    if (input[2] == "male") then 
      centerwire = Geom::Point3d.new(cosa,sina,zzz+0.125)
      pts = []
      pts[0] = [cosa+wire,sina+wire,zzz+wire]
      pts[1] = [cosa+wire,sina-wire,zzz+wire]
      pts[2] = [cosa-wire,sina-wire,zzz+wire]
      pts[3] = [cosa-wire,sina+wire,zzz+wire]
      #edgeszswish = entities.add_circle centerwire, vector2, radius/1.61,10
      faccswish = entities.add_face(pts)
    
      if (faccswish) 
        faccswish.pushpull depth+wire+wire
      end
     
      if (i != 0) 
        wirevex = Geom::Vector3d.new(cosa-lastcosa, sina-lastsina, 0)
        wirevex.normalize!
        wireprp = wirevex.cross Geom::Vector3d.new 0,0,1
        xxx = wireprp.x * wire
        yyy = wireprp.y * wire
        pts = []
        topp = zzz+wire
        if (i.divmod(2)[1] == 1) then topp = zzz - depth - wire end
        pts[0] = [lastcosa+xxx,lastsina+yyy,topp]
        pts[1] = [lastcosa-xxx,lastsina-yyy,topp]
        pts[2] = [cosa-xxx,sina-yyy,topp]
        pts[3] = [cosa+xxx,sina+yyy,topp]
        swish = entities.add_face(pts)
        swish.material =  Sketchup::Color.new(rand(255), rand(255), rand(255))
        if !(swish.normal == Geom::Vector3d.new(0,0,1))
            swish.reverse! end
        if (i.divmod(2)[1] == 1) then swish.pushpull 0-(wire+wire) 
        else swish.pushpull wire+wire end
        lengthacc += Math::sqrt((lastcosa-cosa)*(lastcosa-cosa)+(lastsina-sina)*(lastsina-sina))
        lengthacc += depth
      end
    
      lastcosa = cosa
      lastsina = sina
    end
  end
  return lengthacc
end

def siloh (centerpoint, outer, inner, push)
		entities = Sketchup.active_model.active_entities 
		#centerpoint = Geom::Point3d.new(x,y,z) 
		vector = Geom::Vector3d.new 0,0,1
		vector2 = vector.normalize!
		edgesz = entities.add_circle centerpoint, vector2, outer#,10
		edgeszz = entities.add_circle centerpoint, vector2, inner
		facc = edgesz[0].faces[0] 
		if !(facc.normal == Geom::Vector3d.new(0,0,1))
          facc.reverse! end
		if (facc) then facc.pushpull push end
		facc = edgeszz[0].faces[0] 
		if !(facc.normal == Geom::Vector3d.new(0,0,1))
          facc.reverse! end
		if (facc) then facc.pushpull -centerpoint.z end
		return edgesz
		#transz = Geom::Transformation.scaling(centerpoint, nukescale)
		#entities.transform_entities (transz, edgesz)
end
	
UI.menu("PlugIns").add_item("SHBO SHNT") {
	thick = 0.1
		width = 4.3
		heigh = 3.7
		nukescale = 2
  model = Sketchup.active_model
  entities = model.active_entities   

	pts = []
	pts[0] = [0,0,thick]
	pts[1] = [width,0,thick]
	pts[2] = [width,heigh,thick]
	pts[3] = [0,heigh,thick]
	faccswish = entities.add_face(pts)
	
    if (faccswish) 
      faccswish.pushpull -thick
		 end
		 
	pts = []
	pts[0] = [0.1,0.1,thick]
	pts[1] = [width-0.1,0.1,thick]
	pts[2] = [width-0.1,heigh-0.1,thick]
	pts[3] = [0.1,heigh-0.1,thick]
	faccbzl = entities.add_face(pts)
	if (faccswish) then faccswish.pushpull 0.42 end
	
	midx = 2.15
	
	pts = []
	pts[0] = [midx-0.25,heigh-0.1,thick]
	pts[1] = [midx+0.25,heigh-0.1,thick]
	pts[2] = [midx+0.25,heigh-0.1,thick+0.42]
	pts[3] = [midx-0.25,heigh-0.1,thick+0.42]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull -0.1 end
	pts = []
	midx = midx / 2
	pts[0] = [midx-0.125,heigh-0.1,thick+0.1]
	pts[1] = [midx+0.125,heigh-0.1,thick+0.1]
	pts[2] = [midx+0.125,heigh-0.1,thick+0.42]
	pts[3] = [midx-0.125,heigh-0.1,thick+0.42]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull -0.1 end
	midx = midx * 3
	pts[0] = [midx-0.125,heigh-0.1,thick+0.1]
	pts[1] = [midx+0.125,heigh-0.1,thick+0.1]
	pts[2] = [midx+0.125,heigh-0.1,thick+0.42]
	pts[3] = [midx-0.125,heigh-0.1,thick+0.42]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull -0.1 end
	
	siloh(Geom::Point3d.new(2.150,2.850,thick),0.3,0.2,0.05)

	for i in 0..3 do
		#screwtid(0.5+(i*1.1),1.25,thick)
	end
	for i in 0..3 do
		centerpoint = Geom::Point3d.new(0.5+(i*1.1),0.25,thick) 
		vector = Geom::Vector3d.new 0,0,1
		vector2 = vector.normalize!
		
		edgesz = siloh(centerpoint,0.1,0.0625,0.42)
		transz = Geom::Transformation.scaling(centerpoint, nukescale)
		entities.transform_entities (transz, edgesz)
		
		lowcenterpoint = Geom::Point3d.new(0.5+(i*1.1),0.25,0) 
		hexnut = entities.add_ngon lowcenterpoint, vector2, 0.145,6
		hexfacc = hexnut[1].faces[0] 
		#if !(hexfacc.normal == Geom::Vector3d.new(0,0,1))
        #  hexfacc.reverse! end
		if (hexfacc.typename == "Face") then hexfacc.pushpull -thick end
		
	end
	
	for i in 0..3 do
		centerpoint = Geom::Point3d.new(0.5+(i*1.1),3.45,thick) 
		vector = Geom::Vector3d.new 0,0,1
		vector2 = vector.normalize!
		

		edgesz = siloh(centerpoint,0.1,0.0625,0.42)
		transz = Geom::Transformation.scaling(centerpoint, nukescale)
		entities.transform_entities (transz, edgesz)
		
		lowcenterpoint = Geom::Point3d.new(0.5+(i*1.1),3.45,0) 
		hexnut = entities.add_ngon lowcenterpoint, vector2, 0.145,6
		hexfacc = hexnut[1].faces[0] 
		#if !(hexfacc.normal == Geom::Vector3d.new(0,0,1))
        #  hexfacc.reverse! end
		if (hexfacc.typename == "Face") then hexfacc.pushpull -thick end
	end

    signale(0.1,0.6,width/2, heigh-0.6, thick)
	signale(width/2,0.6,width-0.1, heigh-0.6, thick)
	
}

UI.menu("PlugIns").add_item("SHBO BARR") {
	thick = 0.1
		width = 1
		heigh = 3.7
		nukescale = 2
  model = Sketchup.active_model
  entities = model.active_entities   

	pts = []
	pts[0] = [0,0,thick]
	pts[1] = [width,0,thick]
	pts[2] = [width,heigh,thick]
	pts[3] = [0,heigh,thick]
	faccswish = entities.add_face(pts)
	
    if (faccswish) 
      faccswish.pushpull -thick
		 end
		 
	pts = []
	pts[0] = [0,0.1,thick]
	pts[1] = [width,0.1,thick]
	pts[2] = [width,0,thick]
	pts[3] = [0,0,thick]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull 0.25 end
	
	pts = []
	pts[0] = [0,heigh-0.1,thick]
	pts[1] = [width,heigh-0.1,thick]
	pts[2] = [width,heigh-0,thick]
	pts[3] = [0,heigh-0,thick]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull 0.25 end
	
		oricenterpoint = Geom::Point3d.new(0.5,0.25,thick) 
		oriedgesz = siloh(oricenterpoint,0.1, 0.0625, 0.25)
		
		anicenterpoint = Geom::Point3d.new(0.5,heigh-0.25,thick) 
		aniedgesz = siloh(anicenterpoint,0.1,0.0625,0.25)
		transz = Geom::Transformation.scaling(anicenterpoint, nukescale)
		entities.transform_entities (transz, aniedgesz)
		
		siloh(Geom::Point3d.new(0.3,1,thick),0.299, 0.2, 0.05)
		siloh(Geom::Point3d.new(0.7,0.6,thick),0.299, 0.2, 0.05)
		
		transz = Geom::Transformation.scaling(oricenterpoint, nukescale)
		entities.transform_entities (transz, oriedgesz)
		
		siloh(Geom::Point3d.new(0.25,heigh-0.6,thick), 0.1, 0.0625, 0.05)
		siloh(Geom::Point3d.new(0.75,heigh-0.6,thick), 0.1, 0.0625, 0.05)
}

UI.menu("PlugIns").add_item("SHBO BARRNO") {
	thick = 0.1
		width = 1
		heigh = 3.7
		nukescale = 2
  model = Sketchup.active_model
  entities = model.active_entities   

	pts = []
	pts[0] = [0,0,thick]
	pts[1] = [width,0,thick]
	pts[2] = [width,heigh,thick]
	pts[3] = [0,heigh,thick]
	faccswish = entities.add_face(pts)
	
    if (faccswish) 
      faccswish.pushpull -thick
		 end
		 
	pts = []
	pts[0] = [0,0.1,thick]
	pts[1] = [width,0.1,thick]
	pts[2] = [width,0,thick]
	pts[3] = [0,0,thick]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull 0.25 end
	
	pts = []
	pts[0] = [0,heigh-0.1,thick]
	pts[1] = [width,heigh-0.1,thick]
	pts[2] = [width,heigh-0,thick]
	pts[3] = [0,heigh-0,thick]
	faccbzl = entities.add_face(pts)
	if (faccbzl) then faccbzl.pushpull 0.25 end
	
		oricenterpoint = Geom::Point3d.new(0.5,0.25,thick) 
		oriedgesz = siloh(oricenterpoint,0.1, 0.0625, 0.25)
		
		anicenterpoint = Geom::Point3d.new(0.5,heigh-0.25,thick) 
		aniedgesz = siloh(anicenterpoint,0.1,0.0625,0.25)
		transz = Geom::Transformation.scaling(anicenterpoint, nukescale)
		entities.transform_entities (transz, aniedgesz)
		
		siloh(Geom::Point3d.new(0.3,1,thick),0.299, 0.2, 0.05)
		siloh(Geom::Point3d.new(0.7,0.6,thick),0.299, 0.2, 0.05)
		
		transz = Geom::Transformation.scaling(oricenterpoint, nukescale)
		entities.transform_entities (transz, oriedgesz)

}


unit IAU_FeatureNames_Info;

interface

type
TIAU_FeatureDescriptor = record
  Names,
  Description,
  FT_code : String
  end;

const
  IAU_FeatureTypeList : array[1..53] of TIAU_FeatureDescriptor =
   (
    (Names:'Albedo Feature'; Description:'Geographic area distinguished by amount of reflected light'; FT_code:'AL'),
    (Names:'Arcus, arcus'; Description:'Arc-shaped feature'; FT_code:'AR'),
    (Names:'Astrum, astra'; Description:'Radial-patterned features on Venus'; FT_code:'AS'),
    (Names:'Catena, catenae'; Description:'Chain of craters'; FT_code:'CA'),
    (Names:'Cavus, cavi'; Description:'Hollows, irregular steep-sided depressions usually in arrays or clusters'; FT_code:'CB'),
    (Names:'Chaos, chaoses'; Description:'Distinctive area of broken terrain'; FT_code:'CH'),
    (Names:'Chasma, chasmata'; Description:'A deep, elongated, steep-sided depression'; FT_code:'CM'),
    (Names:'Collis, colles'; Description:'Small hills or knobs'; FT_code:'CO'),
    (Names:'Corona, coronae'; Description:'Ovoid-shaped feature'; FT_code:'CR'),
    (Names:'Crater, craters'; Description:'A circular depression'; FT_code:'AA'),
    (Names:'Dorsum, dorsa'; Description:'Ridge'; FT_code:'DO'),
    (Names:'Eruptive center'; Description:'Active volcanic centers on Io'; FT_code:'ER'),
    (Names:'Facula, faculae'; Description:'Bright spot'; FT_code:'FA'),
    (Names:'Farrum, farra'; Description:'Pancake-like structure, or a row of such structures'; FT_code:'FR'),
    (Names:'Flexus, flexus'; Description:'A very low curvilinear ridge with a scalloped pattern'; FT_code:'FE'),
    (Names:'Fluctus, fluctus'; Description:'Flow terrain'; FT_code:'FL'),
    (Names:'Flumen, flumina'; Description:'Channel on Titan that might carry liquid'; FT_code:'FM'),
    (Names:'Fossa, fossae'; Description:'Long, narrow depression'; FT_code:'FO'),
    (Names:'Insula, insulae'; Description:'Island (islands), an isolated land area (or group of such areas) surrounded by, or nearly surrounded by, a liquid area (sea or lake).'; FT_code:'IN'),
    (Names:'Labes, labes'; Description:'Landslide'; FT_code:'LA'),
    (Names:'Labyrinthus, labyrinthi'; Description:'Complex of intersecting valleys or ridges.'; FT_code:'LB'),
    (Names:'Lacus, lacus'; Description:'"Lake" or small plain; on Titan, a "lake" or small, dark plain with discrete, sharp boundaries'; FT_code:'LC'),
    (Names:'Landing site name'; Description:'Lunar features at or near Apollo landing sites'; FT_code:'LF'),
    (Names:'Large ringed feature'; Description:'Cryptic ringed features'; FT_code:'LG'),
    (Names:'Lenticula, lenticulae'; Description:'Small dark spots on Europa'; FT_code:'LE'),
    (Names:'Linea, lineae'; Description:'A dark or bright elongate marking, may be curved or straight'; FT_code:'LI'),
    (Names:'Lingula, lingulae'; Description:'Extension of plateau having rounded lobate or tongue-like boundaries'; FT_code:'LN'),
    (Names:'Macula, maculae'; Description:'Dark spot, may be irregular'; FT_code:'MA'),
    (Names:'Mare, maria'; Description:'"Sea"; large circular plain; on Titan, large expanses of dark materials thought to be liquid hydrocarbons'; FT_code:'ME'),
    (Names:'Mensa, mensae'; Description:'A flat-topped prominence with cliff-like edges'; FT_code:'MN'),
    (Names:'Mons, montes'; Description:'Mountain'; FT_code:'MO'),
    (Names:'Oceanus, oceani'; Description:'A very large dark area on the moon'; FT_code:'OC'),
    (Names:'Palus, paludes'; Description:'"Swamp"; small plain'; FT_code:'PA'),
    (Names:'Patera, paterae'; Description:'An irregular crater, or a complex one with scalloped edges'; FT_code:'PE'),
    (Names:'Planitia, planitiae'; Description:'Low plain'; FT_code:'PL'),
    (Names:'Planum, plana'; Description:'Plateau or high plain'; FT_code:'PM'),
    (Names:'Plume, plumes'; Description:'Cryo-volcanic features on Triton'; FT_code:'PU'),
    (Names:'Promontorium, promontoria'; Description:'"Cape"; headland promontoria'; FT_code:'PR'),
    (Names:'Regio, regiones'; Description:'A large area marked by reflectivity or color distinctions from adjacent areas, or a broad geographic region'; FT_code:'RE'),
    (Names:'Reticulum, reticula'; Description:'reticular (netlike) pattern on Venus'; FT_code:'RT'),
    (Names:'Rima, rimae'; Description:'Fissure'; FT_code:'RI'),
    (Names:'Rupes, rupes'; Description:'Scarp'; FT_code:'RU'),
    (Names:'Satellite Feature'; Description:'A feature that shares the name of an associated feature. For example, on the Moon the craters referred to as "Lettered Craters" are classified in the gazetteer as "Satellite Features."'; FT_code:'SF'),
    (Names:'Scopulus, scopuli'; Description:'Lobate or irregular scarp'; FT_code:'SC'),
    (Names:'Sinus, sinus'; Description:'"Bay"; small plain'; FT_code:'SI'),
    (Names:'Sulcus, sulci'; Description:'Subparallel furrows and ridges'; FT_code:'SU'),
    (Names:'Terra, terrae'; Description:'Extensive land mass'; FT_code:'TA'),
    (Names:'Tessera, tesserae'; Description:'Tile-like, polygonal terrain'; FT_code:'TE'),
    (Names:'Tholus, tholi'; Description:'Small domical mountain or hill'; FT_code:'TH'),
    (Names:'Unda, undae'; Description:'Dunes'; FT_code:'UN'),
    (Names:'Vallis, valles'; Description:'Valley'; FT_code:'VA'),
    (Names:'Vastitas, vastitates'; Description:'Extensive plain'; FT_code:'VS'),
    (Names:'Virga, virgae'; Description:'A streak or stripe of color'; FT_code:'VI')
   );

function LetteredCraterParentName(const SatelliteFeatureName : String) : String;
{for lunar satellite features}

implementation

uses Win_Ops;

function LetteredCraterParentName(const SatelliteFeatureName : String) : String;
{for lunar satellite features}
var
  ParentName : String;
  CharPos : Integer;
begin
  ParentName := StrippedString(SatelliteFeatureName);
  CharPos := Length(ParentName);
  while (CharPos>0) and (ParentName[CharPos]<>' ') do Dec(CharPos);
  if CharPos>1 then ParentName := Substring(ParentName,1,CharPos-1);
  if Substring(ParentName,1,1)='[' then ParentName := Substring(ParentName,2,CharPos-1);  // discontinued satellite

// special cases of non-crater parents
  if ParentName='Alpes' then ParentName := 'Vallis Alpes'
  else if ParentName='Bouvard' then ParentName :='Vallis Bouvard'
  else if ParentName='Bradley' then ParentName :='Mons Bradley'
  else if ParentName='d''Alembert' then ParentName :='D''Alembert' // capitalization variation in IAU list
  else if ParentName='Gerard Q' then ParentName :='Gerard' // note the two anomalies Gerard Q Inner and Gerard Q Outer for which the parent name is identified as "Gerard" and the letter as "Inner" or "Outer"
  else if ParentName='Hadley' then ParentName :='Mons Hadley'
  else if ParentName='Heraclides' then ParentName :='Promontorium Heraclides'
  else if ParentName='Huygens' then ParentName :='Mons Huygens'
  else if ParentName='Kelvin' then ParentName :='Promontorium Kelvin'
  else if ParentName='La Hire' then ParentName :='Mons La Hire'
  else if ParentName='Laplace' then ParentName :='Promontorium Laplace'
  else if ParentName='Pico' then ParentName :='Mons Pico'
  else if ParentName='Piton' then ParentName :='Mons Piton'
  else if ParentName='Quetelet' then ParentName :='Quételet'  // diacritical variation in IAU list
  else if ParentName='Rümker' then ParentName :='Mons Rümker'
  else if ParentName='Spitzbergen' then ParentName :='Montes Spitzbergen'
  else if ParentName='Wolff' then ParentName :='Mons Wolff';

  LetteredCraterParentName := ParentName;
end;

end.
 
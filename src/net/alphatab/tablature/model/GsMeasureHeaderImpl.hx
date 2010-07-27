/**
 * ...
 * @author Daniel Kuschny
 */

package net.alphatab.tablature.model;
import net.alphatab.model.GsMeasureHeader;
import net.alphatab.model.GsSongFactory;
import net.alphatab.model.GsTrack;
import net.alphatab.model.GsTripletFeel;
import net.alphatab.tablature.ViewLayout;

class GsMeasureHeaderImpl extends GsMeasureHeader
{
	private static inline var DefaultTimeSignatureSpacing:Int = 30;
	private static inline var DefaultLeftSpacing:Int = 15;
	private static inline var DefaultRightSpacing:Int = 15;

	private var _maxClefSpacing:Int;
	private var _maxKeySignatureSpacing:Int;
	
	public var ShouldPaintTempo:Bool;
	public var ShouldPaintTripletFeel:Bool;
	public var ShouldPaintTimeSignature:Bool;
	public var ShouldPaintKeySignature:Bool;

	public var MaxQuarterSpacing:Int;
	public var MaxWidth:Int;

	
	public function new(factory:GsSongFactory) 
	{
		super(factory);
	}
	
	public function Reset() : Void
	{
		MaxWidth = 0;
		MaxQuarterSpacing = 0;

		ShouldPaintTempo = false;
		ShouldPaintTimeSignature = false;
		ShouldPaintKeySignature = false;
		ShouldPaintTripletFeel = false;
		_maxClefSpacing = 0;
		_maxKeySignatureSpacing = 0;
	}

	public function Update(layout:ViewLayout, track:GsTrackImpl) : Void
	{
		Reset();
		CalculateMeasureChanges(layout);

		var measure:GsMeasureImpl = cast track.Measures[Number - 1];
		measure.CalculateMeasureChanges(layout);
	}

	public function CalculateMeasureChanges(layout:ViewLayout) : Void
	{
		var previous:GsMeasureHeader = layout.SongManager().GetPreviousMeasureHeader(this);
		if (previous == null)
		{
			ShouldPaintTempo = true;
			ShouldPaintTripletFeel = TripletFeel != GsTripletFeel.None;
			ShouldPaintTimeSignature = true;
			ShouldPaintKeySignature = true;
		}
		else
		{
			//Tempo
			if (Tempo.Value != previous.Tempo.Value)
			{
				ShouldPaintTempo = true;
			}
			//Triplet Feel
			if (TripletFeel != previous.TripletFeel)
			{
				ShouldPaintTripletFeel = true;
			}
			//Time Signature
			if (TimeSignature.Numerator != previous.TimeSignature.Numerator
				|| TimeSignature.Denominator.Value != previous.TimeSignature.Denominator.Value)
			{
				ShouldPaintTimeSignature = true;
			}
			//Key Signature
			if (KeySignature != previous.KeySignature || KeySignatureType != previous.KeySignatureType)
			{
				ShouldPaintKeySignature = true;
			}
		}
	}


	public function NotifyQuarterSpacing(spacing:Int) : Void
	{
		MaxQuarterSpacing = ((spacing > MaxQuarterSpacing) ? spacing : MaxQuarterSpacing);
	}

	public function GetClefSpacing(layout:ViewLayout, measure:GsMeasureImpl):Int
	{
		return (!measure.IsPaintClef) ? 0 : _maxClefSpacing;
	}

	public function GetKeySignatureSpacing(layout:ViewLayout, measure:GsMeasureImpl):Int
	{
		return (!ShouldPaintKeySignature) ? 0 : _maxKeySignatureSpacing;
	}

	public function GetTempoSpacing(layout:ViewLayout):Int
	{
		return (ShouldPaintTempo && Number == 1 ? Math.round(45 * layout.Scale) : 0);
	}

	public function GetTripletFeelSpacing(layout:ViewLayout):Int
	{
		return (ShouldPaintTripletFeel ? Math.round(55 * layout.Scale) : 0);
	}

	public function GetTimeSignatureSpacing(layout:ViewLayout):Int
	{
		return (ShouldPaintTimeSignature ? Math.round(DefaultTimeSignatureSpacing * layout.Scale) : 0);
	}

	public function GetLeftSpacing(layout:ViewLayout):Int
	{
		return Math.round(DefaultLeftSpacing * layout.Scale);
	}

	public function GetRightSpacing(layout:ViewLayout):Int
	{
		return Math.round(DefaultRightSpacing * layout.Scale);
	}

	public function GetFirstNoteSpacing(layout:ViewLayout, measure:GsMeasureImpl) :Int
	{
		var iTopSpacing:Int = GetTempoSpacing(layout) + GetTripletFeelSpacing(layout);
		var iMiddleSpacing:Int = GetClefSpacing(layout, measure) + GetKeySignatureSpacing(layout, measure) + GetTimeSignatureSpacing(layout);

		return Math.round(Math.max(iTopSpacing, iMiddleSpacing) + (10 * layout.Scale));
	}

	public function NotifyClefSpacing(spacing:Int):Void
	{
		_maxClefSpacing = ((spacing > _maxClefSpacing) ? spacing : _maxClefSpacing);
	}

	public function NotifyKeySignatureSpacing(spacing:Int):Void
	{
		_maxKeySignatureSpacing = ((spacing > _maxKeySignatureSpacing) ? spacing : _maxKeySignatureSpacing);
	}

	public function NotifyWidth(width:Int):Void
	{
		MaxWidth = ((width > MaxWidth) ? width : MaxWidth);
	} 

}
#include "ROOT/RDataFrame.hxx"
#include "TCanvas.h"
#include "TFile.h"
#include "TH1D.h"
#include "TH2D.h"

void mirage_plot(std::string inputFile="input.root", std::string outputFile="output.root"){
    TFile* f = TFile::Open(inputFile.c_str());
    if (!f || f->IsZombie()) return;
    TString treeName = f->GetListOfKeys()->At(0)->GetName();
    ROOT::RDataFrame df(treeName, inputFile);

    auto df_valid = df.Filter("daughterE > 0");

    auto h_energy = df_valid.Histo1D(
        {"h_energy", "Neutrino Energy; Energy (MeV);Counts", 100, 0, 5000},
        "daughterE"
    );

    auto h_profile = df_valid.Histo2D(
        {"h_profile", "Neutrino Profile at ND(574 m); x [mm]; y [mm]", 100, -500, 500, 100, -500, 500},
        "projXat574m", "projYat574m"
    );

    auto h_profile_100m_x_100m = df_valid.Histo2D(
        {"h_profile_100m_x_100m", "Neutrino Profile at ND(574 m); x [mm]; y [mm]", 500, -50000, 50000, 500, -50000, 50000},
        "projXat574m", "projYat574m"
    );

    auto h_profile_10000m_x_10000m = df_valid.Histo2D(
	{"h_profile_10000m_x_10000m", "Neutrino Profile at ND(574 m); x [mm]; y [mm]", 500, -5000000, 5000000, 500, -5000000, 5000000},
	"projXat574m", "projYat574m"
    );

    auto h_profile_1000000m_x_1000000m = df_valid.Histo2D(
	{"h_profile_1000000m_x_1000000m", "Neutrino Profile at ND(574 m); x [mm]; y [mm]", 500, -500000000, 500000000, 500, -500000000, 500000000},
        "projXat574m", "projYat574m"
    );

    TFile out(outputFile.c_str(), "RECREATE");
    h_energy->Write();
    h_profile->Write();
    out.Close();

    std::cout << ">>> Analysis complete: " << outputFile << std::endl;
}

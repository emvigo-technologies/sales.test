import Foundation

protocol RoomsViewModelProtocol {
    func roomsListResponse(message:String,status:Bool,response:[VMCRoomsModelElement])
}

class VMCRoomsViewModel: NSObject{
    
    var delegate: RoomsViewModelProtocol?

    init(withDelegate delegate:RoomsViewModelProtocol) {
        super.init()
        self.delegate = delegate
    }

    //MARK: Fetch Rooms List
    func fetchRooms(){
        VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.show, message: "")
        VMCApiManager.getRoomsData(completion: { message, success, data in
            if success{
                VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.dismiss, message: "")
                self.delegate?.roomsListResponse(message: "", status: true, response: data ?? [])
            }else{
                VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.error, message: message ?? "")
            }
        })
    }
}


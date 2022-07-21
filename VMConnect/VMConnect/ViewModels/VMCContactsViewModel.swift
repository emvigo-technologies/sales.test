import Foundation

protocol ContactsViewModelProtocol {
    func contactListResponse(message:String,status:Bool,response:[VMCContactModelElement])
}

class VMCContactsViewModel: NSObject{
    
    var delegate: ContactsViewModelProtocol?
    var contactsList: [VMCContactModelElement] = []

    init(withDelegate delegate:ContactsViewModelProtocol) {
        super.init()
        self.delegate = delegate
    }

    //MARK: Fetch Contacts
    func fetchContacts(){
        VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.show, message: "")
        VMCApiManager.getContactsData(completion: { message, success, data in
            if success{
                VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.dismiss, message: "")
                self.contactsList = data ?? []
                self.contactSorting()
            }else{
                VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.error, message: message ?? "")
            }
        })
    }
    
    //MARK: Contact List Sorting
    func contactSorting(){
        self.contactsList = self.contactsList.sorted(by: { (Obj1, Obj2) -> Bool in
            let Obj1_Name = Obj1.firstName ?? ""
            let Obj2_Name = Obj2.firstName ?? ""
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
        })
        self.delegate?.contactListResponse(message: "", status: true, response: self.contactsList)
    }
}
